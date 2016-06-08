class Static
  CONTENT_TYPES = {
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
    match_resource = /\/public\/(?<rsc>.*)/.match(req.path)
    if match_resource
      return_resource(match_resource[:rsc])
    else
      @app.call(env)
    end
  end

  def return_resource(resource_name)
    resource_path = File.join(File.dirname(__FILE__),
      "../public/", resource_name)
    begin
      content = File.read(resource_path)
      extension = resource_path[-3..-1]
      ['200', {'Content-Type' => CONTENT_TYPES[extension]}, [content]]
    rescue SystemCallError => e
      ['404', {'Content-Type' => 'text/plain'}, ["404 Nothing to see here..."]]
    end
  end
end
