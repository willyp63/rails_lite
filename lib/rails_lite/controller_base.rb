require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'


class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, url_params = {})
    @req, @res = req, res
    @params = @req.params.merge(url_params)
    @already_built_response = false
    @authenticity_token = nil
    @@protect_from_forgery ||= false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    build_response
    @res.status = 302
    @res['Location'] = url
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    build_response
    @res.write(content)
    @res['Content-Type'] = content_type
  end

  def build_response
    if already_built_response?
      raise "Can't render/redirect twice in the same response"
    end
    session.store_session(@res)
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    views_dir = /^(?<dir>.*)_controller$/.match(self.class.to_s.underscore)[:dir]
    path = Dir.pwd + "/app/views/#{views_dir}/#{template_name}.html.erb"
    content = ERB.new(File.read(path)).result(binding)
    render_content(content, "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    check_authenticity_token if @@protect_from_forgery && @req.request_method == "POST"
    send(name)
    render(name) unless already_built_response?
  end

  # CSRF PROTECTION
  def form_authenticity_token
    set_authenticity_token unless @authenticity_token
    @authenticity_token
  end

  def set_authenticity_token
    @authenticity_token = SecureRandom.urlsafe_base64(16)
    res.set_cookie('authenticity_token', path: '/', value: @authenticity_token)
  end

  def check_authenticity_token
    cookie_auth_token = req.cookies['authenticity_token']
    form_auth_token = @params['authenticity_token']
    unless cookie_auth_token && form_auth_token && cookie_auth_token == form_auth_token
      raise "Invalid authenticity token"
    end
  end

  def self.protect_from_forgery
    @@protect_from_forgery = true
  end
end
