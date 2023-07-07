# frozen_string_literal: true
require 'test_helper'

class MongoidCriteriaMethodsTest < ActiveSupport::TestCase
  sub_test_case '#total_count' do
    setup do
      2.times {|i| User.create!(salary: i) }
    end

    test 'it should reset total_count memoization when the scope is cloned' do
      assert_equal 1, User.page.tap(&:total_count).where(salary: 1).total_count
    end
  end

  sub_test_case '#without_count' do
    setup do
      5.times { User.with(database: 'without_count_db') { |u| u.create!(salary: 1) } }
    end

    test 'it should use default settings for last_page and out_of_range' do
      users = User.max_scan(20).page(1).without_count

      assert_instance_of Mongoid::Criteria, users
      assert_equal false, users.last_page?
      assert_equal false, users.out_of_range?
    end
  end
end

class MongoidExtensionTest < ActiveSupport::TestCase
  setup do
    41.times do
      User.create!({salary: 1})
    end
  end

  teardown do
    User.delete_all
  end

  sub_test_case 'max_scan' do
    sub_test_case 'less than total' do
      test 'page 1' do
        users = User.max_scan(20).page 1

        assert_instance_of Mongoid::Criteria, users
        assert_equal 1, users.current_page
        assert_nil users.prev_page
        assert_nil users.next_page
        assert_equal 25, users.limit_value
        assert_equal 1, users.total_pages
        assert_equal 20, users.total_count
        assert_equal 0, users.instance_variable_get('@options')[:skip]
      end

      test 'page 2' do
        users = User.max_scan(30).page 2

        assert_instance_of Mongoid::Criteria, users
        assert_equal 2, users.current_page
        assert_equal 1, users.prev_page
        assert_nil users.next_page
        assert_equal 25, users.limit_value
        assert_equal 2, users.total_pages
        assert_equal 30, users.total_count
        assert_equal 25, users.instance_variable_get('@options')[:skip]
      end
    end

    sub_test_case 'more than total' do
      test 'page 1' do
        users = User.max_scan(60).page 1

        assert_instance_of Mongoid::Criteria, users
        assert_equal 1, users.current_page
        assert_nil users.prev_page
        assert_equal 2, users.next_page
        assert_equal 25, users.limit_value
        assert_equal 2, users.total_pages
        assert_equal 41, users.total_count
        assert_equal 0, users.instance_variable_get('@options')[:skip]
      end

      test 'page 2' do
        users = User.max_scan(60).page 2

        assert_instance_of Mongoid::Criteria, users
        assert_equal 2, users.current_page
        assert_equal 1, users.prev_page
        assert_nil users.next_page
        assert_equal 25, users.limit_value
        assert_equal 2, users.total_pages
        assert_equal 41, users.total_count
        assert_equal 25, users.instance_variable_get('@options')[:skip]
      end
    end
  end

  sub_test_case '#page' do
    test 'page 1' do
      users = User.page 1

      assert_instance_of Mongoid::Criteria, users
      assert_equal 1, users.current_page
      assert_nil users.prev_page
      assert_equal 2, users.next_page
      assert_equal 25, users.limit_value
      assert_equal 2, users.total_pages
      assert_equal 0, users.instance_variable_get('@options')[:skip]
    end

    test 'page 2' do
      users = User.page 2

      assert_instance_of Mongoid::Criteria, users
      assert_equal 2, users.current_page
      assert_equal 1, users.prev_page
      assert_nil users.next_page
      assert_equal 25, users.limit_value
      assert_equal 2, users.total_pages
      assert_equal 25, users.instance_variable_get('@options')[:skip]
    end

    test 'page "foobar"' do
      users = User.page 'foobar'

      assert_instance_of Mongoid::Criteria, users
      assert_equal 1, users.current_page
      assert_nil users.prev_page
      assert_equal 2, users.next_page
      assert_equal 25, users.limit_value
      assert_equal 2, users.total_pages
      assert_equal 0, users.instance_variable_get('@options')[:skip]
    end

    def assert_complete_valid_pagination(users)
      assert_equal({'salary' => 1}, users.selector)
      assert_equal 2, users.current_page
      assert_equal 1, users.prev_page
      assert_nil users.next_page
      assert_equal 25, users.limit_value
      assert_equal 2, users.total_pages
      assert_equal 25, users.instance_variable_get('@options')[:skip]
    end

    test 'with criteria before' do
      assert_complete_valid_pagination User.where(salary: 1).page(2)
    end

    test 'with criteria after' do
      assert_complete_valid_pagination User.page(2).where(salary: 1)
    end

    sub_test_case 'with database:' do
      setup do
        User.with(database: 'default_db', &:delete_all)
        User.with(database: 'other_db', &:delete_all)
        15.times { User.with(database: 'default_db') {|u| u.create!(salary: 1) } }
        10.times { User.with(database: 'other_db') {|u| u.create!(salary: 1) } }
      end

      test 'default_db' do
        User.with(database: 'default_db') do |u|
          assert_equal 15, u.order_by(:artist.asc).page(1).total_count
        end
      end

      test 'other_db' do
        User.with(database: 'other_db') do |u|
          assert_equal 10, u.order_by(:artist.asc).page(1).total_count
        end
      end
    end
  end

  test '#per' do
    users = User.page(2).per(10)

    assert_instance_of Mongoid::Criteria, users
    assert_equal 2, users.current_page
    assert_equal 1, users.prev_page
    assert_equal 3, users.next_page
    assert_equal 10, users.limit_value
    assert_equal 5, users.total_pages
    assert_equal 10, users.instance_variable_get('@options')[:skip]
  end

  sub_test_case '#page in embedded documents' do
    setup do
      @mongo_developer = MongoMongoidExtensionDeveloper.new
      @mongo_developer.frameworks.new(name: 'rails', language: 'ruby')
      @mongo_developer.frameworks.new(name: 'merb', language: 'ruby')
      @mongo_developer.frameworks.new(name: 'sinatra', language: 'ruby')
      @mongo_developer.frameworks.new(name: 'cakephp', language: 'php')
      @mongo_developer.frameworks.new(name: 'tornado', language: 'python')
    end

    test 'page 1' do
      frameworks = @mongo_developer.frameworks.page(1).per(1)

      assert_instance_of Mongoid::Criteria, frameworks
      assert_equal 1, frameworks.current_page
      assert_nil frameworks.prev_page
      assert_equal 2, frameworks.next_page
      assert_equal 1, frameworks.limit_value
      assert_equal 5, frameworks.total_pages
      assert_equal 5, frameworks.total_count
    end

    test 'with criteria after' do
      frameworks = @mongo_developer.frameworks.page(1).per(2).where(language: 'ruby')

      assert_instance_of Mongoid::Criteria, frameworks
      assert_equal 1, frameworks.current_page
      assert_nil frameworks.prev_page
      assert_equal 2, frameworks.next_page
      assert_equal 2, frameworks.limit_value
      assert_equal 2, frameworks.total_pages
      assert_equal 3, frameworks.total_count
    end

    test 'with criteria before' do
      frameworks = @mongo_developer.frameworks.where(language: 'ruby').page(1).per(2)

      assert_instance_of Mongoid::Criteria, frameworks
      assert_equal 1, frameworks.current_page
      assert_nil frameworks.prev_page
      assert_equal 2, frameworks.next_page
      assert_equal 2, frameworks.limit_value
      assert_equal 2, frameworks.total_pages
      assert_equal 3, frameworks.total_count
    end
  end

  sub_test_case '#paginates_per' do
    test 'when paginates_per is not defined in superclass' do
      assert_equal 25, Product.all.page(1).limit_value
    end

    test 'when paginates_per is defined in subclass' do
      assert_equal 100, Device.all.page(1).limit_value
    end

    test 'when paginates_per is defined in subclass of subclass' do
      assert_equal 200, Android.all.page(1).limit_value
    end
  end
end
