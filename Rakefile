require "bundler/gem_tasks"
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = [FileList['spec/**/*_spec.rb'], FileList["#{File.join(Gem.loaded_specs['kaminari'].gem_dir, 'spec')}/**/*_spec.rb"]].flatten
end

task default: :spec
