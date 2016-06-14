# handles requests for /public/* paths
# attempts to return the static resource at that path
# will raise error if resource type is not supported
# will respond with 404 if the resource could not be found

require 'rack'

class Static
  SUPPORTED_CONTENT_TYPES = {
    "png" => "image/png",
    "jpg" => "image/jpg",
    "txt" => "text/plain",
    "zip" => "application/zip"
  }

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)

    # try to match resource path
    match_resource = /\/public\/(?<rsc>[^.]*).(?<ext>.*)/.match(req.path)
    if match_resource
      respond_with_resource(match_resource[:rsc], match_resource[:ext])
    else
      @app.call(env)
    end
  end

  def respond_with_resource(name, extension)
    unless SUPPORTED_CONTENT_TYPES.keys.include?(extension)
      raise "That static resource type is not supported"
    end

    # attempt to read resource
    resource_path = "#{Dir.pwd}/public/#{name}.#{extension}"
    begin
      content = File.read(resource_path)
      ['200', {'Content-Type' => SUPPORTED_CONTENT_TYPES[extension]}, [content]]
    rescue SystemCallError => e
      ['404', {'Content-Type' => 'text/plain'}, ["404 Nothing to see here!"]]
    end
  end
end
