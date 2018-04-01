# frozen_string_literal: true

class Pagination
  def initialize(total_items:, per:, page:)
    @total_items = total_items
    @per = per
    @page = page
  end

  def current_page
    if @page < 1 then 1
    elsif @page > total_pages then total_pages
    else @page
    end
  end

  def total_pages
    pages = @total_items / @per
    (@total_items % @per).positive? ? pages + 1 : pages
  end

  def next
    current_page + 1 if current_page < total_pages
  end

  def previous
    current_page - 1 if current_page > 1
  end
end
