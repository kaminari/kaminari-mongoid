# frozen_string_literal: true
module Kaminari
  module Mongoid
    module MongoidCriteriaMethods
      def initialize_copy(other) #:nodoc:
        @total_count = nil
        super
      end

      def entry_name(options = {})
        model_name.human(options.reverse_merge(default: model_name.human.pluralize(options[:count])))
      end

      def limit_value #:nodoc:
        options[:limit]
      end

      def offset_value #:nodoc:
        options[:skip]
      end

      def total_count #:nodoc:
        @total_count ||= if embedded?
          unpage.size
        elsif options[:max_scan] && (options[:max_scan] < size)
          options[:max_scan]
        elsif max_pages && (max_pages * limit_value < size)
          max_pages * limit_value
        else
          size
        end
      end

      private
      def unpage
        clone.tap do |crit|
          crit.options.delete :limit
          crit.options.delete :skip
        end
      end
    end
  end
end
