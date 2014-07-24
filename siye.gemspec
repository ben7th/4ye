$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "siye/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "siye"
  s.version     = Siye::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.2"
end