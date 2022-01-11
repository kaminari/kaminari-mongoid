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

      def without_count
        extend ::Kaminari::PaginatableWithoutCount
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

module Kaminari
  module PaginatableWithoutCount
    # Method used to find last page, force setting to false and then use @records.present?
    # in views to determine if link_to_next_page needs to be displayed.
    def last_page?
      false
    end

    # Method used to check if current page greater than total pages, force setting to false and then use @records.present?
    # in views to determine if link_to_next_page needs to be displayed.
    def out_of_range?
      false
    end

    # Force to raise an exception if #total_count is called explicitly.
    def total_count
      raise "This scope is marked as a non-count paginable scope and can't be used in combination " \
            "with `#paginate' or `#page_entries_info'. Use #link_to_next_page or #link_to_previous_page instead."
    end
  end
end
