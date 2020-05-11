module GenericPhrasesHelper
  def map_to_table(generic_phrases)
    generic_phrases.map do |generic_phrase|
      [
        {
          text: "#{generic_phrase[:verb]}-#{generic_phrase[:adjective]}",
        },
        {
          text: generic_phrase[:verb],
        },
        {
          text: generic_phrase[:adjective],
        },
      ]
    end
  end
end
