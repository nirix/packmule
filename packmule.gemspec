require File.expand_path('../lib/packmule/version', __FILE__)
Gem::Specification.new do |s|
  s.name        = 'packmule'
  s.version     = PackMule::VERSION
  s.summary     = "A project packager."
  s.description = "PackMule makes packaging projects into archives easier than ever."
  s.author      = ["Jack Polgar"]
  s.email       = 'nrx@nirix.net'
  s.files       = `git ls-files`.split("\n").sort
  s.executables = ['packmule']
  s.homepage    = 'http://github.com/nirix/packmule'

  s.required_ruby_version = '>= 1.9.2'
  s.add_dependency 'shebang'
end