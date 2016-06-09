Gem::Specification.new do |s|
  s.name        = 'rails_lite'
  s.version     = '1.0.0'
  s.executables << 'rails_lite'

  s.date        = '2016-06-08'
  s.summary     = "Rails Lite"
  s.description = "A simple web developement framework"
  s.authors     = ["Wil Pirino"]
  s.email       = 'wpirino1@gmail.com'
  s.files       = ["lib/rails_lite.rb",
                    "lib/rails_lite/associatable.rb",
                    "lib/rails_lite/controller_base.rb",
                    "lib/rails_lite/db_connection.rb",
                    "lib/rails_lite/flash.rb",
                    "lib/rails_lite/model_base.rb",
                    "lib/rails_lite/router.rb",
                    "lib/rails_lite/searchable.rb",
                    "lib/rails_lite/session.rb",
                    "lib/rails_lite/show_exceptions.rb",
                    "lib/rails_lite/static.rb",
                    "lib/rails_lite/templates/rescue.html.erb"]

  s.homepage    = 'http://rubygems.org/gems/rails_lite'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rack', '~> 1.6', '>= 1.6.0'
  s.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.0'
end
