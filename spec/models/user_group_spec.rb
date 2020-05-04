require "spec_helper"

RSpec.describe UserGroup, type: :model do
  describe "top user groups by date" do
    context "with empty database" do
      it "returns an empty list when no user groups exist" do
        start_date = Date.new(2020, 1, 1)
        end_date = Date.new(2020, 6, 6)

        result = UserGroup.top_user_groups_by_date(start_date, end_date)

        expect(result).to be_empty
      end
    end

    context "with populated database" do
      before :each do
        @local_authority_user_group = FactoryBot.create(:user_group, group: "Local authority")

        survey = FactoryBot.create(:survey, started_at: "2020-02-19")
        FactoryBot.create(:survey_user_group, survey: survey, user_group: @local_authority_user_group)
      end

      it "returns an empty list when no user groups match the date criteria" do
        start_date = Date.new(2020, 3, 1)
        end_date = Date.new(2020, 3, 5)

        result = UserGroup.top_user_groups_by_date(start_date, end_date)

        expect(result).to be_empty
      end

      it "gets the top user groups and totals by date when matching user groups exist" do
        central_gov_user_group = FactoryBot.create(:user_group, group: "Central government")
        surveys = FactoryBot.create_list(:survey, 4, started_at: "2020-02-18")
        surveys.each { |survey| FactoryBot.create(:survey_user_group, survey: survey, user_group: central_gov_user_group) }

        start_date = Date.new(2020, 2, 18)
        end_date = Date.new(2020, 2, 20)
        result = UserGroup.top_user_groups_by_date(start_date, end_date)

        expected_result = [
          { group_name: "Central government", total: 4 },
          { group_name: "Local authority", total: 1 },
        ]

        expect(result).to eq(expected_result)
      end
    end
  end
end
