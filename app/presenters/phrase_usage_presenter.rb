class PhraseUsagePresenter
  attr_reader :pagination, :search_params, :items
  delegate :page, :total_pages, to: :pagination

  def initialize(items, search_params)
    @search_params = search_params
    @pagination = PaginationPresenter.new(page: search_params[:page], total_items: items.count)
    @items = pagination.paginate(items)
  end
end
