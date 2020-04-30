module PhraseHelper
  def map_device_data_to_table(device_data)
    device_data.map do |row|
      [
        { text: row[:device_type] },
        { text: number_to_percentage(row[:percentage_use] * 100, precision: 0), format: "numeric" },
      ]
    end
  end

  def highlighted_survey_answer_html(survey_answer, phrase)
    survey_answer.gsub(/(#{phrase})/i) { |phrase_match| content_tag(:span, phrase_match, class: "phrase-highlight") }
  end
end
