module GenericPhrasesHelper
  def generic_phrase_table_headers(presenter)
    column_map = {
      "generic_phrase" => {
        text: "Generic phrase",
        href: "/generic_phrases?sort_key=generic_phrase&sort_direction=asc",
      },
      "verb" => {
        text: "Verb",
        href: "/generic_phrases?sort_key=verb&sort_direction=asc",
      },
      "adj" => {
        text: "Adjective",
        href: "/generic_phrases?sort_key=adj&sort_direction=asc",
      },
    }

    if presenter.sort_key.present?
      dir = presenter.sort_direction == :asc ? :desc : :asc
      column_map[presenter.sort_key].merge!(
        {
          sort_direction: sort_directions[presenter.sort_direction],
          href: "/generic_phrases?sort_key=#{presenter.sort_key}&sort_direction=#{dir}&page=#{presenter.page}",
        },
      )
    end

    column_map.values
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

private

  def sort_directions
    {
      asc: "ascending",
      desc: "descending",
    }
  end
end
