class PagesPresenter
  include ::PageTitleable
  include ::TableSortable
  include ActionView::Helpers::TagHelper
  attr_reader :items, :verbs, :adjectives, :verb, :adjective
  delegate :page, :total_pages, :total_items, to: :pagination

  def initialize(pages, verbs, adjectives, search_options, start_date, end_date)
    @pagination = PaginationPresenter.new(page: search_options[:page], items_per_page: 50, total_items: pages.count)
    @items = pagination.paginate(pages)
    @verbs = verbs
    @adjectives = adjectives
    @search_options = search_options
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
      sortable_table_head("page_base_path", "Page title", :pages_path),
      sortable_table_head("feedback_comments", "Surveys answered", :pages_path, "numeric"),
      {
        text: "Most frequent phrases",
      },
    ]
  end

private

  attr_reader :pagination, :start_date, :end_date, :search_options

  def page_text(base_path)
    title = page_title(base_path, items)
    href = page_href(base_path)

    content_tag(:a, title, href: href, class: "display-block") +
      content_tag(:span, base_path, class: "govuk-body-s display-block")
  end

  def page_href(base_path)
    parameters = { base_path: base_path.sub(/^\/(?!$)/, "") }
       .merge(from_date: search_options[:from_date] || {})
       .merge(to_date: search_options[:to_date] || {})
    page_path(parameters)
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
