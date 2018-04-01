# frozen_string_literal: true

class Paginate
  attr_reader :records, :pagination

  def initialize(repo:, page:, per: 5)
    @repo = repo
    @page = page
    @per = per
  end

  def perform
    @pagination = Pagination.new(total_items: @repo.size, per: @per, page: @page)
    offset = (@pagination.current_page - 1) * @per
    @records = @repo.offset(offset).limit(@per)
  end
end
