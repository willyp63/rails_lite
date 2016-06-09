Gem::Specification.new do |s|
  s.name        = 'rails_lite'
  s.version     = '1.0.0'
  s.executables << 'rails_lite'

  s.date        = '2016-06-08'
  s.summary     = "Rails Lite"
  s.description = "A simple web developement framework"
  s.authors     = ["Wil Pirino"]
  s.email       = 'wpirino1@gmail.com'
  s.files       = ["lib/active_record_lite/associatable.rb",
                    "lib/active_record_lite/db_connection.rb",
                    "lib/active_record_lite/model_base.rb",
                    "lib/active_record_lite/searchable.rb",
                    "lib/middleware/show_exceptions.rb",
                    "lib/middleware/static.rb",
                    "lib/rails_lite.rb",
                    "lib/rails_lite/controller_base.rb",
                    "lib/rails_lite/flash.rb",
                    "lib/rails_lite/router.rb",
                    "lib/rails_lite/session.rb",
                    "lib/templates/rescue.html.erb"]

  s.homepage    = 'http://rubygems.org/gems/rails_lite'
  s.license     = 'MIT'

  s.add_runtime_dependency 'rack', '~> 1.6', '>= 1.6.0'
  s.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.0'
end
