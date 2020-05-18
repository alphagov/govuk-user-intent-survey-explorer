class GenericPhrasesPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TagHelper
  attr_reader :pagination, :sorting, :search_params, :url_params, :options, :items, :verbs, :adjectives, :verb, :adjective
  delegate :page, :total_pages, :total_items, to: :pagination
  delegate :sort_key, :sort_direction, to: :sorting

  def initialize(generic_phrases, verbs, adjectives, url_params, options)
    @search_params = search_params
    @pagination = PaginationPresenter.new(page: options[:page], total_items: generic_phrases.count)
    @sorting = SortPresenter.new(sort_key: options[:sort_key], sort_direction: options[:sort_direction])
    @url_params = url_params
    @options = options

    @items = pagination.paginate(generic_phrases)
    @verbs = verbs
    @adjectives = adjectives

    @verb = options[:verb]
    @adjective = options[:adjective]
  end

  def table_head
    [
      generic_phrase_head,
      verb_head,
      topic_head,
    ]
  end

  def table_body
    items.map do |generic_phrase_id, generic_phrase, verb, adjective|
      link = content_tag(:a, generic_phrase, href: generic_phrase_path({ id: generic_phrase_id }.merge(url_params)))

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

  def generic_phrase_head
    key = "generic_phrase"
    {
      text: "Generic phrase",
      href: href(key),
    }.merge(sort_direction(key))
  end

  def verb_head
    key = "verb"
    {
      text: "Verb",
      href: href(key),
    }.merge(sort_direction(key))
  end

  def topic_head
    key = "adj"
    {
      text: "Topic",
      href: href(key),
    }.merge(sort_direction(key))
  end

  def href(key)
    direction_for_link = "asc"
    if currently_sorting_by_key?(key)
      direction_for_link = opposite_sort_dir
    end

    sort_params = { sort_key: key, sort_direction: direction_for_link }
    generic_phrases_path(url_params.merge(sort_params).merge(filter_params))
  end

  def filter_params
    {
      verb: options[:verb],
      adjective: options[:adjective],
    }
  end

  def currently_sorting_by_key?(key)
    key == sort_key
  end

  def opposite_sort_dir
    options[:sort_direction] == :desc ? "asc" : "desc"
  end

  def sort_direction(key)
    return {} unless currently_sorting_by_key?(key)

    { sort_direction: sort_directions[options[:sort_direction]] }
  end

  def sort_directions
    {
      asc: "ascending",
      desc: "descending",
    }
  end
end
