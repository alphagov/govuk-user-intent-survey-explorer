require "spec_helper"

RSpec.describe Mention, type: :model do
  describe "mentions by date range for phrase" do
    context "with empty database" do
      it "returns an array keyed by date and containing no mentions" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 11)

        result = Mention.mentions_by_date_range_for_phrase(nil, start_date, end_date)

        expected_result = [[start_date, 0], [end_date, 0]]
        expect(result).to eq(expected_result)
      end
    end

    context "with populated database" do
      before :each do
        @phrase = FactoryBot.create(:phrase)

        create_mentions_for_date("2020-03-10", 1)
        create_mentions_for_date("2020-03-11", 3)
        create_mentions_for_date("2020-03-13", 3)
      end

      it "returns an array keyed by date and containing no mentions when date range matches no mentions" do
        start_date = Date.new(2020, 3, 14)
        end_date = Date.new(2020, 3, 15)

        result = Mention.mentions_by_date_range_for_phrase(@phrase, start_date, end_date)

        expected_result = [[start_date, 0], [end_date, 0]]
        expect(result).to eq(expected_result)
      end

      it "returns mentions data keyed by date when date range matches mentions" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 13)

        result = Mention.mentions_by_date_range_for_phrase(@phrase, start_date, end_date)

        expected_result = [[start_date, 1], [Date.new(2020, 3, 11), 3], [Date.new(2020, 3, 12), 0], [end_date, 3]]
        expect(result).to eq(expected_result)
      end
    end
  end

  describe "mentions by date range for generic phrase" do
    context "with empty database" do
      it "returns an array keyed by date and containing no mentions" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 11)
        generic_phrase = FactoryBot.build(:generic_phrase)

        result = Mention.mentions_by_date_range_for_generic_phrase(generic_phrase, start_date, end_date)

        expected_result = [[start_date, 0], [end_date, 0]]
        expect(result).to eq(expected_result)
      end
    end

    context "with populated database" do
      before :each do
        @phrase = FactoryBot.create(:phrase)
        @generic_phrase = FactoryBot.create(:generic_phrase)

        create_mentions_for_date("2020-03-10", 1)
        create_mentions_for_date("2020-03-11", 3)
        create_mentions_for_date("2020-03-13", 3)

        associate_phrase_with_generic_phrase(@phrase, @generic_phrase)
      end

      it "returns an array keyed by date and containing no mentions when date range matches no mentions" do
        start_date = Date.new(2020, 3, 14)
        end_date = Date.new(2020, 3, 15)

        result = Mention.mentions_by_date_range_for_generic_phrase(@generic_phrase, start_date, end_date)

        expected_result = [[start_date, 0], [end_date, 0]]
        expect(result).to eq(expected_result)
      end

      it "returns mentions data keyed by date when date range matches mentions" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 13)

        second_phrase = FactoryBot.create(:phrase)
        create_mentions_for_date("2020-03-12", 14, phrase: second_phrase)
        create_mentions_for_date("2020-03-13", 5, phrase: second_phrase)
        associate_phrase_with_generic_phrase(second_phrase, @generic_phrase)

        result = Mention.mentions_by_date_range_for_generic_phrase(@generic_phrase, start_date, end_date)

        expected_result = [[start_date, 1], [Date.new(2020, 3, 11), 3], [Date.new(2020, 3, 12), 14], [end_date, 8]]
        expect(result).to eq(expected_result)
      end
    end
  end

  def create_mentions_for_date(date_str, number_of_mentions, phrase: @phrase)
    survey = FactoryBot.create(:survey, started_at: date_str)
    survey_answers = FactoryBot.create_list(:survey_answer, number_of_mentions, survey: survey)
    survey_answers.each { |survey_answer| FactoryBot.create(:mention, survey_answer: survey_answer, phrase: phrase) }
  end

  def associate_phrase_with_generic_phrase(phrase, generic_phrase)
    FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: generic_phrase)
  end
end
