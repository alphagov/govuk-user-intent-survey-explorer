module GenericPhrasesHelper
  def generic_phrase_table_headers(presenter)
    column_map = {
      "generic_phrase" => {
        text: "Generic phrase",
        href: "/generic_phrases?sort_key=generic_phrase&sort_direction=asc&verb=#{presenter.verb}&adjective=#{presenter.adjective}",
      },
      "verb" => {
        text: "Verb",
        href: "/generic_phrases?sort_key=verb&sort_direction=asc&verb=#{presenter.verb}&adjective=#{presenter.adjective}",
      },
      "adj" => {
        text: "Adjective",
        href: "/generic_phrases?sort_key=adj&sort_direction=asc&verb=#{presenter.verb}&adjective=#{presenter.adjective}",
      },
    }

    if presenter.sort_key.present?
      dir = presenter.sort_direction == :asc ? :desc : :asc
      column_map[presenter.sort_key].merge!(
        {
          sort_direction: sort_directions[presenter.sort_direction],
          href: "/generic_phrases?sort_key=#{presenter.sort_key}&sort_direction=#{dir}&verb=#{presenter.verb}&adjective=#{presenter.adjective}",
        },
      )
    end

    column_map.values
  end

  def create_options_for_select_list(items, selected)
    options = [
      {
        text: "Select...",
        value: "",
      },
    ]

    options += items.map do |item|
      {
        text: item,
        value: item,
        selected: item == selected,
      }
    end

    options
  end

  def map_most_frequent_exact_matches_to_table(presenter)
    presenter.most_frequent_exact_matches.map do |_, phrase_text, occurrences|
      [
        {
          text: phrase_text,
        },
        {
          text: occurrences,
          format: "numeric",
        },
      ]
    end
  end

  def map_most_frequent_co_occurring_generic_phrases_to_table(presenter)
    presenter.most_frequent_co_occurring_generic_phrases.map do |generic_phrase_pair, number_of_occurrences|
      [
        {
          text: generic_phrase_pair,
        },
        {
          text: number_of_occurrences,
          format: "numeric",
        },
      ]
    end
  end

private

  def sort_directions
    {
      asc: "ascending",
      desc: "descending",
    }
  end
end
