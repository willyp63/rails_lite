# rescues exceptions raised on the server side
# displays an html page describing the error
# and showing the stack trace

require 'erb'
require 'rack'

class ShowExceptions
  attr_reader :app

  TEMPLATE_PATH = File.join(File.dirname(__FILE__),
    "/../templates/rescue.html.erb")

  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue => e
      render_exception(e)
    end
  end

  private
  def render_exception(e)
    content = ERB.new(File.read(TEMPLATE_PATH)).result(binding)
    ['500', {'Content-Type' => 'text/html'}, ["RuntimeError", content]]
  end
end
