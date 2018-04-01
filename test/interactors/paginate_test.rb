# frozen_string_literal: true

require 'test_helper'

class PaginateTest < ActiveSupport::TestCase
  class MockRepo < Array
    def offset(n)
      self.class.new(slice(n..-1))
    end

    def limit(n)
      self.class.new(slice(0, n))
    end
  end

  test 'it works' do
    repo = MockRepo.new(%w[tony john jason mary tom mark])
    paginate = Paginate.new(repo: repo, page: 2, per: 2)
    paginate.perform
    assert_equal %w[jason mary], paginate.records
  end
end
