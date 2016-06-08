require 'rack'
require_relative 'rails_lite/controller_base'
require_relative 'rails_lite/model_base'
require_relative 'rails_lite/show_exceptions'
require_relative 'rails_lite/static'
require_relative 'rails_lite/router'
require 'active_support/inflector'

module RailsLite
  def RailsLite.router
    @@router ||= Router.new
  end

  def RailsLite.create_app(app_name)
    FileUtils.mkdir(app_name)
    FileUtils.mkdir(app_name + "/app")
    FileUtils.mkdir(app_name + "/app/controllers")
    FileUtils.mkdir(app_name + "/app/models")
    FileUtils.mkdir(app_name + "/app/views")
    FileUtils.mkdir(app_name + "/config")
    FileUtils.mkdir(app_name + "/db")

    # datbase config file
    FileUtils.touch(app_name + "/db/#{app_name.underscore}.sql")

    # routes config file
    file = File.new(app_name + "/config/routes.rb", "w")
    file.write("RailsLite.router.draw do\n\nend")
    file.close
  end

  def RailsLite.load_app
    root = Dir.pwd
    load(root + "/config/routes.rb")
  end

  def RailsLite.start_server
    app = Proc.new do |env|
      req = Rack::Request.new(env)
      res = Rack::Response.new
      router.run(req, res)
      res.finish
    end

    app = Rack::Builder.new do
      use ShowExceptions
      use Static
      run app
    end.to_app

    Rack::Server.start(
     app: app,
     Port: 3000
    )
  end
end
