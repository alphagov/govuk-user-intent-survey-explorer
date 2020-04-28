require 'spec_helper'

RSpec.describe Device, type: :model do
  describe 'breakdown by date range for phrase' do
    context 'with empty database' do
      it 'returns empty array when no data exists' do
        phrase = FactoryBot.build(:phrase)

        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Device.breakdown_by_date_range_for_phrase(phrase, start_date, end_date)

        expect(result).to eq([])
      end
    end

    context 'with populated database' do
      before :each do
        desktop_device = FactoryBot.create(:device, name: 'Desktop')
        tablet_device = FactoryBot.create(:device, name: 'Tablet')
        visitor = FactoryBot.create(:visitor)
        survey = FactoryBot.create(:survey, visitor: visitor, started_at: '2020-03-20')
        survey_answer = FactoryBot.create(:survey_answer, survey: survey)
        @phrase = FactoryBot.create(:phrase)
        FactoryBot.create(:survey_phrase, phrase: @phrase, survey_answer: survey_answer)

        FactoryBot.create_list(:visit, 1, visitor: visitor, device: desktop_device)
        FactoryBot.create_list(:visit, 3, visitor: visitor, device: tablet_device)
      end

      it 'returns empty array when date range matches no data' do
        start_date = Date.new(2020, 3, 10)
        end_date = Date.new(2020, 3, 12)

        result = Device.breakdown_by_date_range_for_phrase(@phrase, start_date, end_date)

        expect(result).to eq([])
      end

      it 'returns device data with totals when date range matches data' do
        start_date = Date.new(2020, 3, 20)
        end_date = Date.new(2020, 3, 22)

        result = Device.breakdown_by_date_range_for_phrase(@phrase, start_date, end_date)

        expect(result).to eq([['Desktop', 1], ['Tablet', 3]])
      end
    end
  end
end
