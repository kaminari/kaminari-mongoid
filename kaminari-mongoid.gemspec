# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaminari/mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = "kaminari-mongoid"
  spec.version       = Kaminari::Mongoid::VERSION
  spec.authors       = ["Akira Matsuda"]
  spec.email         = ["ronnie@dio.jp"]

  spec.summary       = 'Kaminari Mongoid adapter'
  spec.description   = 'kaminari-mongoid lets your Mongoid models be paginatable'
  spec.homepage      = 'https://github.com/kaminari/kaminari-mongoid'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'kaminari-core', '~> 1.0'
  spec.add_dependency 'mongoid'

  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'test-unit-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'rr'
  spec.add_development_dependency 'byebug'
end
