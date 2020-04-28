require 'spec_helper'

RSpec.describe SurveyPhrase, type: :model do
  describe 'mentions by date range for phrase' do
    context 'with empty database' do
      it 'returns an array keyed by date and containing no mentions' do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 11)

        result = SurveyPhrase.mentions_by_date_range_for_phrase(nil, start_date, end_date)

        expected_result = [[start_date, 0], [end_date, 0]]
        expect(result).to eq(expected_result)
      end
    end

    context 'with populated database' do
      before :each do
        @phrase = FactoryBot.create(:phrase)

        create_mentions_for_date('2020-03-10', 1)
        create_mentions_for_date('2020-03-11', 3)
        create_mentions_for_date('2020-03-13', 3)
      end

      it 'returns an array keyed by date and containing no mentions when date range matches no mentions' do
        start_date = Date.new(2020, 3, 14)
        end_date = Date.new(2020, 3, 15)

        result = SurveyPhrase.mentions_by_date_range_for_phrase(@phrase, start_date, end_date)

        expected_result = [[start_date, 0], [end_date, 0]]
        expect(result).to eq(expected_result)
      end

      it 'returns mentions data keyed by date when data range matches mentions' do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 13)

        result = SurveyPhrase.mentions_by_date_range_for_phrase(@phrase, start_date, end_date)

        expected_result = [[start_date, 1], [Date.new(2020, 3, 11), 3], [Date.new(2020, 3, 12), 0], [end_date, 3]]
        expect(result).to eq(expected_result)
      end
    end
  end

  def create_mentions_for_date(date_str, number_of_mentions)
    survey = FactoryBot.create(:survey, started_at: date_str)
    survey_answers = FactoryBot.create_list(:survey_answer, number_of_mentions, survey: survey)
    survey_answers.each { |survey_answer| FactoryBot.create(:survey_phrase, survey_answer: survey_answer, phrase: @phrase) }
  end
end
