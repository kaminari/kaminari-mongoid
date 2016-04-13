# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaminari/mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = "kaminari-mongoid"
  spec.version       = Kaminari::Mongoid::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'Kaminari Mongoid adapter'
  spec.description   = 'Kaminari Mongoid adapter'
  spec.homepage      = 'https://github.com/kaminari/kaminari-mongoid'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'kaminari'
  spec.add_development_dependency 'mongoid'
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'rspec-rails', '~> 2.14.1'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'rr'
  spec.add_development_dependency 'byebug'
end
