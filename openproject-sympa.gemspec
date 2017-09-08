# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/sympa/version'
# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-sympa"
  s.version     = OpenProject::Sympa::VERSION
  s.authors     = "OpenProject GmbH"
  s.email       = "info@openproject.org"
  s.homepage    = "https://community.openproject.org/projects/sympa"
  s.summary     = 'OpenProject Sympa'
  s.description = "Lets you manage sympa mailing lists for projects in OpenProject."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", "~> 5.0"
end
