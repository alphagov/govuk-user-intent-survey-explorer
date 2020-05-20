def create_phrases_for_page(page, survey_started_at, number_of_phrases, minimum_number_of_mentions = 1)
  visitor = FactoryBot.create(:visitor)
  survey = FactoryBot.create(:survey, started_at: survey_started_at)
  survey_answer = FactoryBot.create(:survey_answer, survey: survey)
  number_of_phrases.times do |index|
    phrase = FactoryBot.create(:phrase, phrase_text: "I need assistance #{index + 1}")
    (index + minimum_number_of_mentions).times do
      FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)
    end

    generic_phrase = FactoryBot.create(:generic_phrase)
    FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: generic_phrase)
  end

  visit = FactoryBot.create(:visit, visitor: visitor)
  FactoryBot.create(:page_visit, page: page, visit: visit)
  FactoryBot.create(:survey_visit, survey: survey, visit: visit)
end
