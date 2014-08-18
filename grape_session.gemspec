# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape_session/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape_session'
  spec.version       = GrapeSession::VERSION
  spec.authors       = ['Dieter Späth']
  spec.email         = ['d.spaeth@faber.de']
  spec.summary       = 'Adds Rails like session support to grape api'
  spec.description   = 'Adds Rails like session support to grape api'
  spec.homepage      = 'https://github.com/faber-lotto/grape_session'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rack', '>= 1.3.0'
  spec.add_runtime_dependency 'rack-mount'
  spec.add_runtime_dependency 'rack-accept'
  spec.add_runtime_dependency 'activesupport', '>=4.1.0'
  spec.add_runtime_dependency 'actionpack', '>=4.1.0'
  spec.add_runtime_dependency 'grape_cookies'

  spec.add_development_dependency 'grape'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec', '3.0'
  # show nicely how many specs have to be run
  spec.add_development_dependency 'fuubar'
  # extended console
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  # https://github.com/pry/pry-stack_explorer
  spec.add_development_dependency 'pry-stack_explorer'
  # https://github.com/deivid-rodriguez/pry-byebug
  # pre-debugger / debugger does not work with ruby 2.x
  spec.add_development_dependency 'pry-byebug'

  # automatic execute tasks on file changes
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'rb-fsevent'

end
