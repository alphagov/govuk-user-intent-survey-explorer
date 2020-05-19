module TrendingHelper
  def map_pages_data_to_ordered_list(data)
    data.map do |base_path, _|
      link = "https://www.gov.uk#{base_path}"

      { base_path: base_path, govuk_link: link }
    end
  end

  def map_generic_phrases_to_ordered_list(data)
    data.map do |id, generic_phrase, _|
      { generic_phrase: generic_phrase, link: generic_phrase_path(id) }
    end
  end
end
