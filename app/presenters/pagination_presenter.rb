class PaginationPresenter
  include Kaminari::Helpers::HelperMethods
  attr_reader :page, :total_items, :total_pages

  def initialize(page: 1, total_items:)
    @items_per_page = 15

    @page = page.to_i
    @total_items = total_items
    @total_pages = (@total_items.to_f / @items_per_page).ceil
  end

  def paginate(items)
    Kaminari.paginate_array(items, total_count: total_items).page(page).per(@items_per_page)
  end
end
