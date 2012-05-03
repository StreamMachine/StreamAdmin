$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stream_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stream_admin"
  s.version     = StreamAdmin::VERSION
  s.authors     = ["Eric Richardson"]
  s.email       = ["e@ericrichardson.com"]
  s.homepage    = "http://github.com/SCPR/StreamAdmin"
  s.summary     = "Admin interface and stats for StreamMachine"
  s.description = "Admin interface and stats for StreamMachine"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.3"
  
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
