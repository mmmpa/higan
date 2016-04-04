$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "higan/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "higan"
  s.version     = Higan::VERSION
  s.authors     = ["mmmpa"]
  s.email       = ["mmmpa.mmmpa@gmail.com"]
  s.homepage    = "https://github.com/mmmpa/higan"
  s.summary     = "Support making static HTML files from records."
  s.description = "Support making static HTML files from records."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5.2"
  s.add_dependency 'slim-rails'
  s.add_dependency 'kaminari'
  s.add_dependency 'squeel'

  s.add_development_dependency "sqlite3"

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'poltergeist'

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'spring-commands-rspec'
end
