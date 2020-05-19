require "spec_helper"

RSpec.describe SurveyAnswer, type: :model do
  describe "for phrase" do
    context "with empty database" do
      it "returns no survey answers" do
        phrase = FactoryBot.create(:phrase)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_phrase(phrase, start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns no survey answers when no survey answers associated with phrase" do
        phrase_with_answers = FactoryBot.create(:phrase, phrase_text: "find help")
        phrase_without_answers = FactoryBot.create(:phrase)
        create_survey_answers_for_phrase(phrase_with_answers, "2020-03-11")

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_phrase(phrase_without_answers, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns no survey answers when associated answers exist but date range filter does not match surveys" do
        phrase_with_answers = FactoryBot.create(:phrase, phrase_text: "find help")
        create_survey_answers_for_phrase(phrase_with_answers, "2020-03-11")

        start_date = Date.new(2020, 3, 12)
        end_date = Date.new(2020, 3, 14)

        result = SurveyAnswer.for_phrase(phrase_with_answers, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns survey answers when associated answers exist and date range filter matches surveys" do
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

  describe "for generic phrase" do
    context "with empty database" do
      it "returns no survey answers" do
        generic_phrase = FactoryBot.create(:generic_phrase)
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_generic_phrase(generic_phrase, start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      it "returns no survey answers when no survey answers associated with generic phrase" do
        phrase_with_generic_phrase = FactoryBot.create(:phrase)
        phrase_without_generic_phrase = FactoryBot.create(:phrase)
        generic_phrase_with_phrases = FactoryBot.create(:generic_phrase)
        generic_phrase_without_phrases = FactoryBot.create(:generic_phrase)

        create_survey_answers_for_phrase(phrase_with_generic_phrase, "2020-03-11")
        create_survey_answers_for_phrase(phrase_without_generic_phrase, "2020-03-11")
        associate_phrase_with_generic_phrase(phrase_with_generic_phrase, generic_phrase_with_phrases)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_generic_phrase(generic_phrase_without_phrases, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns no survey answers when associated generic phrases exist but date range filter does not match surveys" do
        phrase = FactoryBot.create(:phrase)
        generic_phrase = FactoryBot.create(:generic_phrase)

        create_survey_answers_for_phrase(phrase, "2020-03-08")
        associate_phrase_with_generic_phrase(phrase, generic_phrase)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_generic_phrase(generic_phrase, start_date, end_date)

        expect(result).to be_empty
      end

      it "returns survey answers when associated generic phrases exist and date range filter matches surveys" do
        phrase1 = FactoryBot.create(:phrase)
        phrase2 = FactoryBot.create(:phrase)
        generic_phrase = FactoryBot.create(:generic_phrase)

        survey_answers = create_survey_answers_for_phrase(phrase1, "2020-03-10", 2)
        survey_answers += create_survey_answers_for_phrase(phrase2, "2020-03-12", 3)
        associate_phrase_with_generic_phrase(phrase1, generic_phrase)
        associate_phrase_with_generic_phrase(phrase2, generic_phrase)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = SurveyAnswer.for_generic_phrase(generic_phrase, start_date, end_date)

        expect(result).to eq(survey_answers)
        expect(result.count).to eq(5)
      end
    end
  end
  # TODO: Write spec for SurveyAnswer.for_page
end

def create_survey_answers_for_phrase(phrase, survey_started_at, number_of_answers = 1)
  survey = FactoryBot.create(:survey, started_at: survey_started_at)
  survey_answers = FactoryBot.create_list(:survey_answer, number_of_answers, survey: survey)

  survey_answers.each do |answer|
    FactoryBot.create(:mention, phrase: phrase, survey_answer: answer)
  end

  survey_answers
end
