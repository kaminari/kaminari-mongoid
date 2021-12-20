# frozen_string_literal: true
source 'https://rubygems.org'

# Specify your gem's dependencies in kaminari-mongoid.gemspec
gemspec

unless ENV['CI']
  gem 'kaminari-core', path: 'kaminari/kaminari'
  gem 'kaminari-actionview', github: 'kaminari/kaminari'
end
