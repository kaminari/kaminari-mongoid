# frozen_string_literal: true
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(Gem.loaded_specs['kaminari-core'].gem_dir, 'test'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rails'

require 'bundler/setup'
Bundler.require

# for kaminari view test
ActiveSupport.on_load :action_controller do
  prepend_view_path File.join(Gem.loaded_specs['kaminari-core'].gem_dir, 'test/fake_app/views')
end

require 'database_cleaner'

require 'fake_app/rails_app'
require 'fake_app/mongoid/config'
require 'fake_app/mongoid/models'

require 'test/unit/rails/test_help'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.join(Gem.loaded_specs['kaminari-core'].gem_dir, 'test')}/support/**/*.rb"].each {|f| require f}
