require 'rack'
require_relative 'router'
require_relative 'show_exceptions'
require_relative 'static'
require_relative 'controller_base'

class MyController < ControllerBase
  def go
    render_content("Hello from the controller", "text/html")
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/$"), MyController, :go
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

app = Rack::Builder.new do
  user ShowExceptions
  use Static
  run app
end.to_app

Rack::Server.start(
 app: app,
 Port: 3000
)
