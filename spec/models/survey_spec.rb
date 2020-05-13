require "spec_helper"

RSpec.describe Survey, type: :model do
  describe "count_by_date" do
    context "with empty database" do
      it "returns hash with all dates but no count" do
        page = FactoryBot.build(:page)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        expected_result = {
          "10 Mar" => 0,
          "11 Mar" => 0,
          "12 Mar" => 0,
        }
        result = Survey.count_by_date(page, start_date, end_date)
        expect(result).to eq(expected_result)
      end
    end

    context "with populated database" do
      it "returns hash with all dates but no count when date range matches no data" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        page = FactoryBot.build(:page)
        create_survey_for_date("2020-03-20", page)

        expected_result = {
          "10 Mar" => 0,
          "11 Mar" => 0,
          "12 Mar" => 0,
        }
        result = Survey.count_by_date(page, start_date, end_date)
        expect(result).to eq(expected_result)
      end

      it "returns hash with correct counts for dates in date range" do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        page = FactoryBot.build(:page)
        create_survey_for_date("2020-03-10", page)

        2.times do
          create_survey_for_date("2020-03-11", page)
        end

        3.times do
          create_survey_for_date("2020-03-12", page)
        end

        expected_result = {
          "10 Mar" => 1,
          "11 Mar" => 2,
          "12 Mar" => 3,
        }
        result = Survey.count_by_date(page, start_date, end_date)
        expect(result).to eq(expected_result)
      end
    end
  end

  def create_survey_for_date(survey_started_at, page)
    survey = FactoryBot.create(:survey, started_at: survey_started_at)
    visit = FactoryBot.create(:visit)
    FactoryBot.create(:survey_visit, survey: survey, visit: visit)
    FactoryBot.create(:page_visit, page: page, visit: visit)
  end
end
