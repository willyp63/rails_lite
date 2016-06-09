require_relative 'middleware/show_exceptions'
require_relative 'middleware/static'
require_relative 'rails_lite/router'
require_relative 'rails_lite/controller_base'
require_relative 'active_record_lite/db_connection'
require_relative 'active_record_lite/model_base'

module RailsLite
  def RailsLite.router
    @router ||= Router.new
  end

  def RailsLite.init_project(project_name)
    commands = [
      "mkdir -p #{project_name}/app/controllers",
      "mkdir -p #{project_name}/app/models",
      "mkdir -p #{project_name}/app/views",
      "mkdir -p #{project_name}/config",
      "mkdir -p #{project_name}/db",
      "touch #{project_name}/db/#{project_name.underscore}.sql",
      "touch #{project_name}/config/routes.rb",
      "echo 'RailsLite.router.draw do\n\nend' > #{project_name}/config/routes.rb",
    ]
    # exececute commands in console
    commands.each { |command| `#{command}` }
  end

  def RailsLite.reset_database
    DBConnection.reset
  end

  def RailsLite.start_server
    # load routes
    load(Dir.pwd + "/config/routes.rb")

    # router handles requests
    app = Proc.new do |env|
      req = Rack::Request.new(env)
      res = Rack::Response.new
      router.run(req, res)
      res.finish
    end

    # middleware
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
