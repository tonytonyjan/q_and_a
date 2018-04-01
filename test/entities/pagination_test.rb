# frozen_string_literal: true

require 'test_helper'

class PaginationTest < ActiveSupport::TestCase
  test '#current_page' do
    assert_equal 3, Pagination.new(total_items: 10, per: 3, page: 3).current_page
    assert_equal 1, Pagination.new(total_items: 10, per: 3, page: -1).current_page
    assert_equal 4, Pagination.new(total_items: 10, per: 3, page: 100).current_page
  end

  test '#total_pages' do
    assert_equal 4, Pagination.new(total_items: 10, per: 3, page: 1).total_pages
    assert_equal 5, Pagination.new(total_items: 10, per: 2, page: 1).total_pages
    assert_equal 2, Pagination.new(total_items: 10, per: 5, page: 1).total_pages
  end

  test '#next' do
    assert_equal 2, Pagination.new(total_items: 10, per: 3, page: 1).next
    assert_equal 3, Pagination.new(total_items: 10, per: 3, page: 2).next
    assert_nil Pagination.new(total_items: 10, per: 3, page: 4).next
  end

  test '#previous' do
    assert_nil Pagination.new(total_items: 10, per: 3, page: 1).previous
    assert_equal 1, Pagination.new(total_items: 10, per: 3, page: 2).previous
  end
end
