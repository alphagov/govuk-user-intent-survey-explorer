require "spec_helper"

RSpec.describe GenericPhrase, type: :model do
  describe "generic phrases search" do
    context "with empty database" do
      it "returns no generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        result = GenericPhrase.search(start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      before :each do
        @generic_phrase = create_generic_phrase("2020-03-20", verb: "find", adjective: "help")
      end

      it "returns no generic phrases when date range matches no generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        result = GenericPhrase.search(start_date, end_date)

        expect(result).to be_empty
      end

      it "returns generic phrases when date range matches generic phrases" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)

        result = GenericPhrase.search(start_date, end_date)

        expect(result.count).to eq(1)
        expect(id(result.first)).to eq(@generic_phrase.id)
        expect(generic_phrase(result.first)).to eq("#{@generic_phrase.verb.name}-#{@generic_phrase.adjective.name}")
        expect(verb(result.first)).to eq(@generic_phrase.verb.name)
        expect(adjective(result.first)).to eq(@generic_phrase.adjective.name)
      end

      it "returns generic phrases ordered by default sort key and direction when no sort options are specified" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)
        create_generic_phrase("2020-03-21", verb: "apply", adjective: "passport")
        create_generic_phrase("2020-03-22", verb: "purchase", adjective: "book")
        create_generic_phrase("2020-03-23", verb: "pay", adjective: "fine")

        result = GenericPhrase.search(start_date, end_date)

        expect(result.count).to eq(4)
        expect(result.map { |_, generic_phrase, _, _| generic_phrase }).to eq(%w[apply-passport find-help pay-fine purchase-book])
      end

      it "returns generic phrases ordered by sort key and default sort direction when sort key is specified" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)
        create_generic_phrase("2020-03-21", verb: "apply", adjective: "passport")
        create_generic_phrase("2020-03-22", verb: "purchase", adjective: "book")
        create_generic_phrase("2020-03-23", verb: "pay", adjective: "fine")

        result = GenericPhrase.search(start_date, end_date, { sort_key: "verb" })

        expect(result.count).to eq(4)
        expect(result.map { |_, _, verb, _| verb }).to eq(%w[apply find pay purchase])
      end

      it "returns generic phrases ordered by sort direction and default sort key when sort direction is specified" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)
        create_generic_phrase("2020-03-21", verb: "apply", adjective: "passport")
        create_generic_phrase("2020-03-22", verb: "purchase", adjective: "book")
        create_generic_phrase("2020-03-23", verb: "pay", adjective: "fine")

        result = GenericPhrase.search(start_date, end_date, { sort_dir: "desc" })

        expect(result.count).to eq(4)
        expect(result.map { |_, _, verb, _| verb }).to eq(%w[purchase pay find apply])
      end

      it "returns generic phrases ordered by sort key and direction when sort key and direction are specified" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)
        create_generic_phrase("2020-03-21", verb: "apply", adjective: "passport")
        create_generic_phrase("2020-03-22", verb: "purchase", adjective: "book")
        create_generic_phrase("2020-03-23", verb: "pay", adjective: "fine")

        result = GenericPhrase.search(start_date, end_date, { sort_key: "adj", sort_dir: "asc" })

        expect(result.count).to eq(4)
        expect(result.map { |_, _, _, adj| adj }).to eq(%w[book fine help passport])
      end

      it "returns generic phrases filtered by verb when matching verb exists as part of generic phrases" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)
        verb_query = "buy"
        create_generic_phrase("2020-03-21", verb: verb_query, adjective: "books")
        create_generic_phrase("2020-03-22", verb: verb_query, adjective: "calendars")

        result = GenericPhrase.search(start_date, end_date, { verb: verb_query })

        expect(result.count).to eq(2)
        expect(generic_phrase(result.first)).to eq("#{verb_query}-books")
        expect(generic_phrase(result.last)).to eq("#{verb_query}-calendars")
      end

      it "returns generic phrases filtered by adjective when matching adjective exists as part of generic phrases" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)
        adjective_query = "diary"
        create_generic_phrase("2020-03-19", verb: "find", adjective: adjective_query)
        create_generic_phrase("2020-03-23", verb: "purchase", adjective: adjective_query)

        result = GenericPhrase.search(start_date, end_date, { adjective: adjective_query })

        expect(result.count).to eq(2)
        expect(generic_phrase(result.first)).to eq("find-#{adjective_query}")
        expect(generic_phrase(result.last)).to eq("purchase-#{adjective_query}")
      end

      it "returns generic phrases filtered by verb and adjective when matching generic phrases exist" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)
        verb_query = "buy"
        adjective_query = "diary"
        create_generic_phrase("2020-03-21", verb: verb_query, adjective: adjective_query)
        create_generic_phrase("2020-03-23", verb: verb_query, adjective: adjective_query)

        result = GenericPhrase.search(start_date, end_date, { verb: verb_query, adjective: adjective_query })

        expect(result.count).to eq(2)
        expect(generic_phrase(result.first)).to eq("#{verb_query}-#{adjective_query}")
        expect(generic_phrase(result.last)).to eq("#{verb_query}-#{adjective_query}")
      end
    end
  end

  describe "most frequent co-occurring for generic phrase" do
    context "with empty database" do
      it "should return no generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)
        generic_phrase = FactoryBot.build(:generic_phrase)

        result = GenericPhrase.most_frequent_co_occurring(generic_phrase, start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "should return no generic phrases when date range matches no generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        phrases = FactoryBot.create_list(:phrase, 2)
        create_survey_with_phrases("2020-03-20", phrases: phrases)

        generic_phrase1 = create_generic_phrase_model("find", "information")
        generic_phrase2 = create_generic_phrase_model("apply", "license")
        associate_phrase_with_generic_phrase(phrases.first, generic_phrase1)
        associate_phrase_with_generic_phrase(phrases.last, generic_phrase2)

        result = GenericPhrase.most_frequent_co_occurring(generic_phrase1, start_date, end_date)

        expect(result).to be_empty
      end

      it "should return no generic phrases when date range matches single generic phrase in different surveys" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        phrases = FactoryBot.create_list(:phrase, 2)
        create_survey_with_phrases("2020-03-12", phrases: [phrases.first])
        create_survey_with_phrases("2020-03-13", phrases: [phrases.last])

        generic_phrase1 = create_generic_phrase_model("find", "information")
        generic_phrase2 = create_generic_phrase_model("apply", "license")
        associate_phrase_with_generic_phrase(phrases.first, generic_phrase1)
        associate_phrase_with_generic_phrase(phrases.last, generic_phrase2)

        result = GenericPhrase.most_frequent_co_occurring(generic_phrase1, start_date, end_date)

        expect(result).to be_empty
      end

      it "should return generic phrases when date range matches multiple generic phrases in single survey answer" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        phrases = FactoryBot.create_list(:phrase, 3)
        create_survey_with_phrases("2020-03-12", phrases: phrases)

        generic_phrase1 = create_generic_phrase_model("find", "information")
        generic_phrase2 = create_generic_phrase_model("apply", "license")
        generic_phrase3 = create_generic_phrase_model("acquire", "delivery")
        associate_phrase_with_generic_phrase(phrases.first, generic_phrase1)
        associate_phrase_with_generic_phrase(phrases.second, generic_phrase2)
        associate_phrase_with_generic_phrase(phrases.last, generic_phrase3)

        expected = [
          ["acquire-delivery-apply-license", 1],
          ["acquire-delivery-find-information", 1],
          ["apply-license-find-information", 1],
        ]

        result = GenericPhrase.most_frequent_co_occurring(generic_phrase1, start_date, end_date)

        expect(result).to eq(expected)
      end

      it "should return generic phrases when date range matches multiple generic phrases in multiple survey answers" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        phrases = FactoryBot.create_list(:phrase, 3)
        create_survey_with_phrases("2020-03-12", phrases: [phrases.first, phrases.second])
        create_survey_with_phrases("2020-03-13", phrases: [phrases.second, phrases.third, phrases.first])

        generic_phrase1 = create_generic_phrase_model("find", "information")
        generic_phrase2 = create_generic_phrase_model("apply", "license")
        generic_phrase3 = create_generic_phrase_model("acquire", "delivery")
        associate_phrase_with_generic_phrase(phrases.first, generic_phrase1)
        associate_phrase_with_generic_phrase(phrases.second, generic_phrase2)
        associate_phrase_with_generic_phrase(phrases.last, generic_phrase3)

        result = GenericPhrase.most_frequent_co_occurring(generic_phrase2, start_date, end_date)

        expected = [
          ["apply-license-find-information", 2],
          ["acquire-delivery-apply-license", 1],
          ["acquire-delivery-find-information", 1],
        ]

        expect(result).to eq(expected)
      end

      it "should ignore survey answers which only contain one generic phrase when returning results" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        phrases = FactoryBot.create_list(:phrase, 3)
        create_survey_with_phrases("2020-03-13", phrases: [phrases.second, phrases.third, phrases.first])
        create_survey_with_phrases("2020-03-13", phrases: [phrases.second])
        create_survey_with_phrases("2020-03-13", phrases: [phrases.first, phrases.second])

        generic_phrase1 = create_generic_phrase_model("find", "information")
        generic_phrase2 = create_generic_phrase_model("apply", "license")
        generic_phrase3 = create_generic_phrase_model("acquire", "delivery")
        associate_phrase_with_generic_phrase(phrases.first, generic_phrase1)
        associate_phrase_with_generic_phrase(phrases.second, generic_phrase2)
        associate_phrase_with_generic_phrase(phrases.last, generic_phrase3)

        result = GenericPhrase.most_frequent_co_occurring(generic_phrase2, start_date, end_date)

        expected = [
          ["apply-license-find-information", 2],
          ["acquire-delivery-apply-license", 1],
          ["acquire-delivery-find-information", 1],
        ]

        expect(result).to eq(expected)
      end
    end
  end

  describe "most frequent" do
    context "with empty database" do
      it "returns no generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        result = GenericPhrase.most_frequent(start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns no generic phrases when date range matches no surveys" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        phrases = FactoryBot.create_list(:phrase, 3)
        create_survey_with_phrases("2020-03-08", phrases: [phrases.first, phrases.second])
        create_survey_with_phrases("2020-03-16", phrases: [phrases.second, phrases.third])

        generic_phrase1 = create_generic_phrase_model("apply", "license")
        generic_phrase2 = create_generic_phrase_model("find", "information")
        generic_phrase3 = create_generic_phrase_model("acquire", "delivery")
        associate_phrase_with_generic_phrase(phrases.first, generic_phrase1)
        associate_phrase_with_generic_phrase(phrases.second, generic_phrase2)
        associate_phrase_with_generic_phrase(phrases.third, generic_phrase3)

        result = GenericPhrase.most_frequent(start_date, end_date)

        expect(result).to be_empty
      end

      it "returns generic phrases when date range matches surveys and generic phrases exist" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        phrases = FactoryBot.create_list(:phrase, 3)
        create_survey_with_phrases("2020-03-10", phrases: [phrases.first, phrases.second])
        create_survey_with_phrases("2020-03-15", phrases: [phrases.second, phrases.third])

        generic_phrase1 = create_generic_phrase_model("apply", "license")
        generic_phrase2 = create_generic_phrase_model("find", "information")
        generic_phrase3 = create_generic_phrase_model("acquire", "delivery")
        associate_phrase_with_generic_phrase(phrases.first, generic_phrase1)
        associate_phrase_with_generic_phrase(phrases.second, generic_phrase2)
        associate_phrase_with_generic_phrase(phrases.third, generic_phrase3)

        expected = [
          [generic_phrase2.id, "find-information", 2],
          [generic_phrase3.id, "acquire-delivery", 1],
          [generic_phrase1.id, "apply-license", 1],
        ]

        result = GenericPhrase.most_frequent(start_date, end_date)

        expect(result).to eq(expected)
      end
    end
  end

  describe "most_frequent_for_page" do
    context "with empty database" do
      it "returns no generic phrases" do
        page = FactoryBot.create(:page)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        result = GenericPhrase.most_frequent_for_page(page, start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns no generic phrases when date range matches no generic phrases" do
        page = FactoryBot.create(:page)
        create_generic_phrase("2020-03-20", verb: "find", adjective: "help", page: page)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        result = GenericPhrase.most_frequent_for_page(page, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns generic phrases when date range matches generic phrases" do
        page = FactoryBot.create(:page)
        create_generic_phrase("2020-03-10", verb: "find", adjective: "help", page: page)
        create_generic_phrase("2020-03-10", verb: "find", adjective: "information", page: page)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        expected_result = [
          { phrase_text: "find-help", total: 1 },
          { phrase_text: "find-information", total: 1 },
        ]

        result = GenericPhrase.most_frequent_for_page(page, start_date, end_date)

        expect(result).to eq(expected_result)
      end
    end
  end

  describe "first_appeared" do
    it "returns datetime that generic phrase first appeared" do
      expected_first_appeared_at = DateTime.new(2020, 3, 5)

      phrase = FactoryBot.create(:phrase)
      generic_phrase = create_generic_phrase_model("find", "help")
      associate_phrase_with_generic_phrase(phrase, generic_phrase)

      create_survey_with_phrases("2020-03-10", phrases: [phrase])
      create_survey_with_phrases(expected_first_appeared_at.strftime("%F"), phrases: [phrase])

      result = GenericPhrase.find(generic_phrase.id)

      expect(result.first_appeared_at).to eq(expected_first_appeared_at)
    end
  end

  describe "to string" do
    it "returns stringified generic phrase" do
      verb = FactoryBot.create(:verb, name: "apply")
      adjective = FactoryBot.create(:adjective, name: "license")
      generic_phrase = FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)

      expect(generic_phrase.to_s).to eq("apply-license")
    end
  end
end

def id(result)
  result[0]
end

def generic_phrase(result)
  result[1]
end

def verb(result)
  result[2]
end

def adjective(result)
  result[3]
end

def create_generic_phrase(survey_start_date, verb: "", adjective: "", phrases: [FactoryBot.create(:phrase)], page: nil)
  survey = FactoryBot.create(:survey, started_at: survey_start_date)
  survey_answer = FactoryBot.create(:survey_answer, survey: survey)

  verb = FactoryBot.create(:verb, name: verb)
  adjective = FactoryBot.create(:adjective, name: adjective)
  generic_phrase = FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)

  phrases.each do |phrase|
    FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)
    FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: generic_phrase)
  end

  if page
    visitor = FactoryBot.create(:visitor)
    visit = FactoryBot.create(:visit, visitor: visitor)
    FactoryBot.create(:page_visit, page: page, visit: visit)
    FactoryBot.create(:survey_visit, survey: survey, visit: visit)
  end

  generic_phrase
end
