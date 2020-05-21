def create_survey_with_phrases(survey_start_date, phrases: [FactoryBot.create(:phrase)])
  survey = FactoryBot.create(:survey, started_at: survey_start_date)
  survey_answer = FactoryBot.create(:survey_answer, survey: survey)

  phrases.each do |phrase|
    FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)
  end

  survey
end
