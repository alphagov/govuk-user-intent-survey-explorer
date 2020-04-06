class SummaryPresenter
  attr_reader :pagination, :sorting, :search_params, :content_pages

  def initialize(items, search_params)
    @search_params = search_params
    @pagination = PaginationPresenter.new(page: search_params[:page], total_items: items.count)
    @sorting = SortPresenter.new(sort_key: search_params[:sort_key], sort_direction: search_params[:sort_direction])

    @content_pages = pagination.paginate(items)
  end
end
