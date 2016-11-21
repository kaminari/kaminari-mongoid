# frozen_string_literal: true
DatabaseCleaner[:mongoid].strategy = :truncation

class ActiveSupport::TestCase
  class << self
    def startup
      DatabaseCleaner.clean_with :truncation
      super
    end
  end

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end
