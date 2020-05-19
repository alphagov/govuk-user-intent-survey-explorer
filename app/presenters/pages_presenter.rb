class PagesPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TagHelper
  include ::PageTitleable
  attr_reader :items, :verbs, :adjectives, :verb, :adjective
  delegate :page, :total_pages, :total_items, to: :pagination

  def initialize(pages, verbs, adjectives, search_results_page, url_params, search_options, start_date, end_date)
    @pagination = PaginationPresenter.new(page: search_results_page, items_per_page: 50, total_items: pages.count)
    @items = pagination.paginate(pages)
    @verbs = verbs
    @adjectives = adjectives
    @url_params = url_params
    @sort_key = search_options[:sort_key]
    @sort_dir = search_options[:sort_dir]
    @verb = search_options[:verb]
    @adjective = search_options[:adjective]
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

  def page_text(base_path)
    title = page_title(base_path, items)
    href = page_href(base_path)

    content_tag(:a, title, href: href, class: "display-block") +
      content_tag(:span, base_path, class: "govuk-body-s display-block")
  end

  def page_href(base_path)
    p url_params
    parameters = { base_path: base_path.sub(/^\/(?!$)/, "") }
       .merge(from_date: url_params[:from_date] || {})
       .merge(to_date: url_params[:to_date] || {})
    page_path(parameters)
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

    phrase_content_tag(0, phrases) +
      phrase_content_tag(1, phrases) +
      phrase_content_tag(2, phrases)
  end

  def phrase_content_tag(index, phrases)
    if phrases[index].present?
      return content_tag(:span, phrases[index][:phrase_text], class: "phrase")
    end

    ""
  end
end
