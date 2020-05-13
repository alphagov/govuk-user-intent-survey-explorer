class PagesPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TagHelper
  attr_reader :items
  delegate :page, :total_pages, :total_items, to: :pagination

  def initialize(pages, search_results_page, url_params, sort_key, sort_dir, start_date, end_date)
    @pagination = PaginationPresenter.new(page: search_results_page, items_per_page: 50, total_items: pages.count)
    @items = pagination.paginate(pages)
    @url_params = url_params
    @sort_key = sort_key
    @sort_dir = sort_dir
    @start_date = start_date
    @end_date = end_date
  end

  def rows
    items.map do |page|
      [
        { text: page_text(page[:base_path]) },
        { text: page[:survey_count], format: "numeric" },
        { text: top_phrases(page) },
      ]
    end
  end

  def head
    [
      page_title_head,
      surveys_answered_head,
      {
        text: "Most frequent phrases",
      },
    ]
  end

private

  attr_reader :pagination, :url_params, :sort_key, :sort_dir, :start_date, :end_date
  attr_accessor :page_titles

  def page_text(base_path)
    title = page_title(base_path)

    content_tag(:a, title, href: base_path, class: "display-block") +
      content_tag(:span, base_path, class: "govuk-body-s display-block")
  end

  def page_title(base_path)
    # Search API doesn't index all documents, so it won't always return
    # a result for every base path we pass it.
    return search_api_page_titles[base_path] if search_api_page_titles.has_key?(base_path)

    # If the search results don't include the base path we want
    # we hit the Content Store API, which will
    begin
      content_store_page_title(base_path)
    rescue GdsApi::ContentStore::ItemNotFound, GdsApi::InvalidUrl
      # Sometimes we can have a url that the content store does not recognise
      # because we're relying on urls from a non canonical source
      # (for example if it has a lot of parameters in it or it's a sub item of another)
      # We need to find a long term solution to this
      ""
    end
  end

  def search_api_page_titles
    @search_api_page_titles ||= begin
      Services.search_api.search(
        count: items.count,
        filter_link: item_base_paths,
        fields: %i[link title],
      )
        .to_hash["results"]
        .each_with_object({}) { |result, hash| hash[result["link"]] = result["title"] }
    end
  end

  def item_base_paths
    @item_base_paths ||= items.map { |item| item[:base_path] }
  end

  def content_store_page_title(base_path)
    Services.content_store.content_item(base_path)["title"]
  end

  def page_title_head
    key = "page_base_path"
    {
      text: "Page title",
      href: href(key),
    }.merge(sort_direction(key))
  end

  def surveys_answered_head
    key = "feedback_comments"
    {
      text: "Surveys answered",
      format: "numeric",
      href: href(key),
    }.merge(sort_direction(key))
  end

  def href(key)
    direction_for_link = sort_dir
    if currently_sorting_by_key?(key)
      direction_for_link = opposite_sort_dir
    end

    sort_params = { sort_key: key, sort_dir: direction_for_link }
    pages_path(url_params.merge(sort_params))
  end

  def opposite_sort_dir
    sort_dir == "desc" ? "asc" : "desc"
  end

  def sort_direction(key)
    return {} unless currently_sorting_by_key?(key)

    { sort_direction: sort_dir }
  end

  def currently_sorting_by_key?(key)
    key == sort_key
  end

  def top_phrases(page)
    phrases = Phrase.top_phrases_for_page(page[:page_id], start_date, end_date).take(3)

    content_tag(:span, phrases.first, class: "phrase") +
      content_tag(:span, phrases.second, class: "phrase") +
      content_tag(:span, phrases.third, class: "phrase")
  end
end
