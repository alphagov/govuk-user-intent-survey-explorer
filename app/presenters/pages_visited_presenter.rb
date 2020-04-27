class PagesVisitedPresenter
  attr_reader :pagination, :sorting, :search_params, :items
  delegate :page, :total_pages, to: :pagination

  def initialize(items, search_params)
    @search_params = search_params
    @pagination = PaginationPresenter.new(page: search_params[:page], total_items: items.count)
    @sorting = SortPresenter.new(sort_key: search_params[:sort_key], sort_direction: search_params[:sort_direction])

    @items = pagination.paginate(items)
  end
end