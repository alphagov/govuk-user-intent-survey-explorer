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

def create_generic_phrase(survey_start_date, verb: "", adjective: "")
  phrase = FactoryBot.create(:phrase)
  survey = FactoryBot.create(:survey, started_at: survey_start_date)
  survey_answer = FactoryBot.create(:survey_answer, survey: survey)
  FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)

  verb = FactoryBot.create(:verb, name: verb)
  adjective = FactoryBot.create(:adjective, name: adjective)
  generic_phrase = FactoryBot.create(:generic_phrase, verb: verb, adjective: adjective)
  FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: generic_phrase)

  generic_phrase
end
