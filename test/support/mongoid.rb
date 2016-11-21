# frozen_string_literal: true
class ActiveSupport::TestCase
  class << self
    def startup
      # Mongoid 5 is very noisy at DEBUG level by default
      Mongoid.logger.level = Logger::INFO
      Mongo::Logger.logger.level = Logger::INFO if defined?(Mongo)
      super
    end
  end
end
