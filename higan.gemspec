$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "higan/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "higan"
  s.version     = Higan::VERSION
  s.authors     = ["mmmpa"]
  s.email       = ["mmmpa.mmmpa@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Higan."
  s.description = "TODO: Description of Higan."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5.2"

  s.add_development_dependency "sqlite3"
end
