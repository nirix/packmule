# -*- encoding: utf-8 -*-
require File.expand_path('../lib/packmule/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "packmule"
  gem.version       = Packmule::VERSION
  gem.authors       = ["Jack Polgar"]
  gem.email         = ["nrx@nirix.net"]
  gem.summary       = "Project packaging made easy."
  gem.description   = "Packmule makes packaging projects into archives easier than ever."
  gem.homepage      = "https://github.com/nirix/packmule"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'shebang'
  gem.add_dependency 'rubyzip'
end
