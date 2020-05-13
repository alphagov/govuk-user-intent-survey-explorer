require "spec_helper"

RSpec.describe Phrase, type: :model do
  describe "most frequent" do
    context "with empty database" do
      it "returns no phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Phrase.most_frequent(start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns no phrases when date range filter matches no surveys" do
        survey = FactoryBot.create(:survey, started_at: "2020-03-13")
        survey_answer = FactoryBot.create(:survey_answer, survey: survey)
        phrase = FactoryBot.create(:phrase)
        FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Phrase.most_frequent(start_date, end_date)

        expect(result).to be_empty
      end

      it "returns phrases ordered by most frequently occurring when date range filter matches surveys" do
        survey = FactoryBot.create(:survey, started_at: "2020-03-13")
        survey_answer = FactoryBot.create(:survey_answer, survey: survey)
        phrase1 = FactoryBot.create(:phrase, phrase_text: "find information")
        FactoryBot.create_list(:mention, 3, phrase: phrase1, survey_answer: survey_answer)
        phrase2 = FactoryBot.create(:phrase, phrase_text: "volunteering opportunities")
        FactoryBot.create_list(:mention, 10, phrase: phrase2, survey_answer: survey_answer)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 14)

        result = Phrase.most_frequent(start_date, end_date)

        expect(result.to_a.count).to eq(2)
        expect(result.first.phrase_text).to eq(phrase2.phrase_text)
        expect(result.last.phrase_text).to eq(phrase1.phrase_text)
      end
    end
  end

  describe "top_phrases_for_page" do
    context "with empty database" do
      it "returns no pages" do
        start_date = Date.new(2020, 3, 2)
        end_date = Date.new(2020, 3, 20)
        result = Phrase.top_phrases_for_page(1, start_date, end_date)
        expect(result).to be_empty
      end
    end

    context "page without any phrases" do
      it "returns no pages" do
        page = FactoryBot.create(:page)
        start_date = Date.new(2020, 3, 2)
        end_date = Date.new(2020, 3, 20)
        result = Phrase.top_phrases_for_page(page.id, start_date, end_date)
        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns phrases in order of number of mentions" do
        page = FactoryBot.create(:page)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 20)

        create_phrases_for_page(page, start_date, 3)

        result = Phrase.top_phrases_for_page(page.id, start_date, end_date)
        expect(result).to eq(["I need assistance 3", "I need assistance 2", "I need assistance 1"])
      end

      it "returns no pages when date filter matches no surveys" do
        page = FactoryBot.create(:page)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 20)

        create_phrases_for_page(page, end_date + 1.day, 3)

        result = Phrase.top_phrases_for_page(page.id, start_date, end_date)
        expect(result).to be_empty
      end
    end
  end
end
