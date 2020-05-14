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

  def map_verbs_to_table(presenter)
    options = [
      {
        text: "Select...",
        value: "",
      },
    ]

    options += presenter.verbs.map do |verb|
      {
        text: verb,
        value: verb,
        selected: verb == presenter.verb,
      }
    end

    options
  end

  def map_adjectives_to_table(presenter)
    options = [
      {
        text: "Select...",
        value: "",
      },
    ]

    options += presenter.adjectives.map do |adj|
      {
        text: adj,
        value: adj,
        selected: adj == presenter.adjective,
      }
    end

    options
  end

  def map_to_table(presenter)
    presenter.items.map do |generic_phrase_id, generic_phrase, verb, adjective|
      link = link_to generic_phrase, generic_phrase_path(id: generic_phrase_id)

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

  def map_responses_data_to_chart(data)

  end

private

  def sort_directions
    {
      asc: "ascending",
      desc: "descending",
    }
  end
end
