# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in kaminari-mongoid.gemspec
gemspec

if ENV['CI']
  gem 'kaminari-core', github: 'kaminari/kaminari'
  gem 'kaminari-actionview', github: 'kaminari/kaminari'
else
  gem 'kaminari-core', path: '../kaminari'
  gem 'kaminari-actionview', path: '../kaminari'
end


if ENV['MONGOID_VERSION'] == 'head'
  gem 'mongoid', git: 'https://github.com/mongodb/mongoid.git'
  gem 'railties'
elsif ENV['MONGOID_VERSION']
  gem 'mongoid', "~> #{ENV['MONGOID_VERSION']}.0"

  mongoid_version = Gem::Version.new ENV['MONGOID_VERSION']
  if mongoid_version >= Gem::Version.new('7')
    if RUBY_VERSION >= '2.5'
      gem 'railties', '~> 6.1'
    else
      gem 'railties', '~> 5.2'
    end
  elsif mongoid_version >= Gem::Version.new('6.2')
    gem 'railties', '~> 5.2'
  elsif mongoid_version >= Gem::Version.new('6')
    gem 'railties', '~> 5.0'
  else
    gem 'railties', '~> 4.0'
  end
else
  gem 'mongoid'
  gem 'railties'
end

gem 'selenium-webdriver'

gem 'mime-types'
