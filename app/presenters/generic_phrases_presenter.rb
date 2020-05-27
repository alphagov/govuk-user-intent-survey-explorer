class GenericPhrasesPresenter
  include ::TableSortable
  include ActionView::Helpers::TagHelper
  attr_reader :pagination, :items, :verbs, :adjectives, :verb, :adjective
  delegate :page, :total_pages, :total_items, to: :pagination

  def initialize(generic_phrases, verbs, adjectives, search_options)
    @search_options = search_options
    @pagination = PaginationPresenter.new(page: search_options[:page], total_items: generic_phrases.count)
    @search_options = search_options

    @items = pagination.paginate(generic_phrases)
    @verbs = verbs
    @adjectives = adjectives

    @verb = search_options[:verb]
    @adjective = search_options[:adjective]
  end

  def table_head
    [
      sortable_table_head("generic_phrase", "Generic phrase", :generic_phrases_path),
      sortable_table_head("verb", "Verb", :generic_phrases_path),
      sortable_table_head("adj", "Topic", :generic_phrases_path),
    ]
  end

  def table_body
    items.map do |generic_phrase_id, generic_phrase, verb, adjective|
      link = content_tag(:a, generic_phrase, href: generic_phrase_path({ id: generic_phrase_id }.merge(search_options)))

      [
        {
          text: link,
        },
        {
          text: verb,
        },
        {
          text: adjective,
        },
      ]
    end
  end

private

  attr_reader :search_options
end
