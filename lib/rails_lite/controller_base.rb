require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative 'session'
require_relative 'flash'


class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req, @res = req, res
    @params = @req.params.merge(route_params)
    @already_built_response = false
    @authenticity_token = nil
    @@protect_from_forgery ||= false
  end

  def redirect_to(url)
    build_response
    @res.status = 302
    @res['Location'] = url
  end

  def render(template_name)
    views_dir = /^(?<dir>.*)_controller$/.match(self.class.to_s.underscore)[:dir]
    path = Dir.pwd + "/app/views/#{views_dir}/#{template_name}.html.erb"

    content = ERB.new(File.read(path)).result(binding)
    render_content(content, "text/html")
  end

  def render_content(content, content_type)
    build_response
    @res.write(content)
    @res['Content-Type'] = content_type
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name)
    if @@protect_from_forgery && @req.request_method != "GET"
      check_authenticity_token
    end
    send(name)

    # render appropriate view if no response
    render(name) unless @already_built_response
  end

  # CSRF
  def self.protect_from_forgery
    @@protect_from_forgery = true
  end

  def form_authenticity_token
    set_authenticity_token unless @authenticity_token
    @authenticity_token
  end

  private
  def build_response
    if @already_built_response
      raise "Can't render/redirect twice in the same response"
    end
    # add cookies to response
    flash.store_flash(@res)
    session.store_session(@res)

    @already_built_response = true
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
end
