require 'spec_helper'

RSpec.describe SurveyAnswer, type: :model do
  describe 'for phrase' do
    context 'with empty database' do
      it 'returns no survey answers' do
        phrase = FactoryBot.create(:phrase)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_phrase(phrase, start_date, end_date)

        expect(result).to be_empty
      end
    end

    context 'with populated database' do
      it 'returns no survey answers when no survey answers associated with phrase' do
        phrase_with_answers = FactoryBot.create(:phrase, phrase_text: "find help")
        phrase_without_answers = FactoryBot.create(:phrase)
        create_survey_answers_for_phrase(phrase_with_answers, "2020-03-11")

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_phrase(phrase_without_answers, start_date, end_date)

        expect(result).to be_empty
      end

      it 'returns no survey answers when associated answers exist but date range filter does not match surveys' do
        phrase_with_answers = FactoryBot.create(:phrase, phrase_text: "find help")
        create_survey_answers_for_phrase(phrase_with_answers, "2020-03-11")

        start_date = Date.new(2020, 3, 12)
        end_date = Date.new(2020, 3, 14)

        result = SurveyAnswer.for_phrase(phrase_with_answers, start_date, end_date)

        expect(result).to be_empty
      end

      it 'returns survey answers when associated answers exist and date range filter matches surveys' do
        phrase_with_answers = FactoryBot.create(:phrase, phrase_text: "find help")
        different_phrase_with_answers = FactoryBot.create(:phrase)

        create_survey_answers_for_phrase(different_phrase_with_answers, "2020-03-11", 3)
        survey_answers = create_survey_answers_for_phrase(phrase_with_answers, "2020-03-11", 2)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_phrase(phrase_with_answers, start_date, end_date)

        expect(result.count).to eq(2)
        expect(result.first).to eq(survey_answers.first)
        expect(result.last).to eq(survey_answers.last)
      end
    end
  end
end

def create_survey_answers_for_phrase(phrase, survey_started_at, number_of_answers = 1)
  survey = FactoryBot.create(:survey, started_at: survey_started_at)
  survey_answers = FactoryBot.create_list(:survey_answer, number_of_answers, survey: survey)

  survey_answers.each do |answer|
    FactoryBot.create(:mention, phrase: phrase, survey_answer: answer)
  end

  survey_answers
end
