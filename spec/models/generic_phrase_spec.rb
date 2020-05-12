require "spec_helper"

RSpec.describe GenericPhrase, type: :model do
  describe "generic phrases by date range" do
    context "with empty database" do
      it "returns no generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        result = GenericPhrase.for_date_range(start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      before :each do
        phrase = FactoryBot.create(:phrase)
        @generic_phrase = FactoryBot.create(:generic_phrase)
        FactoryBot.create(:phrase_generic_phrase, phrase: phrase, generic_phrase: @generic_phrase)
        survey = FactoryBot.create(:survey, started_at: "2020-03-20")
        survey_answer = FactoryBot.create(:survey_answer, survey: survey)
        FactoryBot.create(:mention, phrase: phrase, survey_answer: survey_answer)
      end

      it "returns no generic phrases when date range matches no generic phrases" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 15)

        result = GenericPhrase.for_date_range(start_date, end_date)

        expect(result).to be_empty
      end

      it "returns generic phrases when date range matches generic phrases" do
        start_date = Date.new(2020, 3, 15)
        end_date = Date.new(2020, 3, 23)

        result = GenericPhrase.for_date_range(start_date, end_date)

        expect(result.count).to eq(1)
        expect(id(result.first)).to eq(@generic_phrase.id)
        expect(verb(result.first)).to eq(@generic_phrase.verb.name)
        expect(adjective(result.first)).to eq(@generic_phrase.adjective.name)
      end
    end
  end
end

def id(result)
  result[0]
end

def verb(result)
  result[1]
end

def adjective(result)
  result[2]
end
