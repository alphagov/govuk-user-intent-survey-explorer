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

  describe "most_frequent_for_generic_phrase" do
    context "with empty database" do
      it "returns no phrases" do
        generic_phrase = FactoryBot.build(:generic_phrase)
        start_date = Date.new(2020, 3, 2)
        end_date = Date.new(2020, 3, 20)
        result = Phrase.most_frequent_for_generic_phrase(generic_phrase, start_date, end_date)
        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns no phrases when date range filter matches no surveys" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)
        phrase = FactoryBot.create(:phrase)
        generic_phrase = FactoryBot.create(:generic_phrase)
        create_survey_for_phrase("2020-03-15", phrase)
        associate_generic_phrase_with_phrase(generic_phrase, phrase)

        result = Phrase.most_frequent_for_generic_phrase(generic_phrase, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns no phrases when phrase has no associated generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)
        phrase = FactoryBot.create(:phrase)
        create_survey_for_phrase("2020-03-11", phrase)
        generic_phrase = FactoryBot.create(:generic_phrase)

        result = Phrase.most_frequent_for_generic_phrase(generic_phrase, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns phrases when phrase has associated generic phrases" do
        verb = FactoryBot.create(:verb, name: "find")
        adjective = FactoryBot.create(:adjective, name: "help")
        generic_phrase = FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)

        phrases = [
          FactoryBot.create(:phrase, phrase_text: "I want to get some help"),
          FactoryBot.create(:phrase, phrase_text: "Sources of information"),
        ]

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        phrases.each do |phrase|
          create_survey_for_phrase("2020-03-11", phrase)
          associate_generic_phrase_with_phrase(generic_phrase, phrase)
        end

        result = Phrase.most_frequent_for_generic_phrase(generic_phrase, start_date, end_date)

        expect(phrase_text_with_occurrences(result.first)).to eq(["I want to get some help", 1])
        expect(phrase_text_with_occurrences(result.last)).to eq(["Sources of information", 1])
      end

      it "returns phrases grouped by occurrences when phrase has duplicate generic phrases associations" do
        verb = FactoryBot.create(:verb, name: "find")
        adjective = FactoryBot.create(:adjective, name: "help")
        generic_phrase = FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)

        phrase1 = FactoryBot.create(:phrase, phrase_text: "I want to get some help")
        phrase2 = FactoryBot.create(:phrase, phrase_text: "Sources of information")
        phrase3 = FactoryBot.create(:phrase, phrase_text: "Help with volunteering")

        create_survey_for_phrase("2020-03-11", phrase1)
        create_survey_for_phrase("2020-03-11", phrase2)
        create_survey_for_phrase("2020-03-11", phrase3)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        phrases = [phrase3, phrase1, phrase2, phrase3, phrase1, phrase3]
        phrases.each do |phrase|
          associate_generic_phrase_with_phrase(generic_phrase, phrase)
        end

        result = Phrase.most_frequent_for_generic_phrase(generic_phrase, start_date, end_date)

        expect(phrase_text_with_occurrences(result.first)).to eq([phrase3.phrase_text, 3])
        expect(phrase_text_with_occurrences(result.second)).to eq([phrase1.phrase_text, 2])
        expect(phrase_text_with_occurrences(result.third)).to eq([phrase2.phrase_text, 1])
      end

      it "returns phrases grouped by occurrences when phrase has multiple survey answer mentions" do
        verb = FactoryBot.create(:verb, name: "find")
        adjective = FactoryBot.create(:adjective, name: "help")
        generic_phrase = FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)

        phrase1 = FactoryBot.create(:phrase, phrase_text: "I want to get some help")
        phrase2 = FactoryBot.create(:phrase, phrase_text: "Sources of information")
        phrase3 = FactoryBot.create(:phrase, phrase_text: "Help with volunteering")

        create_survey_for_phrase("2020-03-11", phrase1)
        create_survey_for_phrase("2020-03-11", phrase1)
        create_survey_for_phrase("2020-03-11", phrase2)
        create_survey_for_phrase("2020-03-11", phrase2)
        create_survey_for_phrase("2020-03-11", phrase2)
        create_survey_for_phrase("2020-03-11", phrase3)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        phrases = [phrase1, phrase2, phrase3]
        phrases.each do |phrase|
          associate_generic_phrase_with_phrase(generic_phrase, phrase)
        end

        result = Phrase.most_frequent_for_generic_phrase(generic_phrase, start_date, end_date)

        expect(phrase_text_with_occurrences(result.first)).to eq([phrase2.phrase_text, 3])
        expect(phrase_text_with_occurrences(result.second)).to eq([phrase1.phrase_text, 2])
        expect(phrase_text_with_occurrences(result.third)).to eq([phrase3.phrase_text, 1])
      end

      it "returns phrases grouped by occurrences when phrase has duplicate generic phrases associations and survey answer mentions" do
        verb = FactoryBot.create(:verb, name: "find")
        adjective = FactoryBot.create(:adjective, name: "help")
        generic_phrase = FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)

        phrase1 = FactoryBot.create(:phrase, phrase_text: "I want to get some help")
        phrase2 = FactoryBot.create(:phrase, phrase_text: "Sources of information")
        phrase3 = FactoryBot.create(:phrase, phrase_text: "Help with volunteering")

        create_survey_for_phrase("2020-03-11", phrase1)
        create_survey_for_phrase("2020-03-11", phrase1)
        create_survey_for_phrase("2020-03-11", phrase2)
        create_survey_for_phrase("2020-03-11", phrase2)
        create_survey_for_phrase("2020-03-11", phrase2)
        create_survey_for_phrase("2020-03-11", phrase3)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        phrases = [phrase3, phrase2, phrase2, phrase1, phrase1]
        phrases.each do |phrase|
          associate_generic_phrase_with_phrase(generic_phrase, phrase)
        end

        result = Phrase.most_frequent_for_generic_phrase(generic_phrase, start_date, end_date)

        expect(phrase_text_with_occurrences(result.first)).to eq([phrase2.phrase_text, 6])
        expect(phrase_text_with_occurrences(result.second)).to eq([phrase1.phrase_text, 4])
        expect(phrase_text_with_occurrences(result.third)).to eq([phrase3.phrase_text, 1])
      end
    end
  end
end

def create_survey_for_phrase(survey_start_date, phrase)
  survey = FactoryBot.create(:survey, started_at: survey_start_date)
  survey_answer = FactoryBot.create(:survey_answer, survey: survey)
  FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)
end

def associate_generic_phrase_with_phrase(generic_phrase, phrase)
  FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: generic_phrase)
end

def phrase_text_with_occurrences(result)
  [result[1], result[2]]
end
