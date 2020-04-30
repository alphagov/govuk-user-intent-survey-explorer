class PagesVisitedPresenter
  attr_reader :pagination, :sorting, :search_params, :items, :phrase
  delegate :page, :total_pages, to: :pagination
  delegate :sort_key, :sort_direction, to: :sorting

  def initialize(phrase, items, search_params)
    @phrase = phrase
    @search_params = search_params
    @pagination = PaginationPresenter.new(page: search_params[:page], total_items: items.count)
    @sorting = SortPresenter.new(sort_key: search_params[:sort_key], sort_direction: search_params[:sort_direction])

    @items = pagination.paginate(items)
  end
end
