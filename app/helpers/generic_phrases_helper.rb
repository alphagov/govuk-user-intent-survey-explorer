module GenericPhrasesHelper
  def map_to_table(presenter)
    presenter.items.map do |generic_phrase_id, verb, adjective|
      link = link_to "#{verb}-#{adjective}", generic_phrase_path(id: generic_phrase_id)

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
end
