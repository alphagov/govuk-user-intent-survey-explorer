class PhraseUsagePresenter
  attr_reader :pagination, :search_params, :survey_answers_containing_phrase

  def initialize(items, search_params)
    @search_params = search_params
    @pagination = PaginationPresenter.new(page: search_params[:page], total_items: items.count)
    @survey_answers_containing_phrase = pagination.paginate(items)
  end
end
