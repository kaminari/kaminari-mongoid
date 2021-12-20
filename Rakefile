# frozen_string_literal: true
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "{test,#{File.join(Gem.loaded_specs['kaminari-core'].gem_dir, 'test')}}/**/*_test.rb"
  t.warning = false
  t.verbose = true
end

task default: :test
