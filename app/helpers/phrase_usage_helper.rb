module PhraseUsageHelper
  def highlighted_survey_answer_html(survey_answer, phrase)
    survey_answer.gsub(/(#{phrase})/i){ |match| "<span class='phrase-highlight'>#{match}</span>" }.html_safe
  end
end
