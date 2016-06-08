Gem::Specification.new do |s|
  s.name        = 'rails_lite'
  s.version     = '0.0.0'
  s.executables << 'rails_lite'

  s.date        = '2016-06-08'
  s.summary     = "Rails Lite"
  s.description = "A simple web developement framework"
  s.authors     = ["Wil Pirino"]
  s.email       = 'wpirino1@gmail.com'
  s.files       = ["lib/rails_lite.rb"]
  s.homepage    = 'http://rubygems.org/gems/rails_lite'
  s.license     = 'MIT'

  s.add_dependency 'rack'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rspec'
end
