require "spec_helper"

RSpec.describe Adjective, type: :model do
  describe "unique verbs" do
    it "should get unique verbs ordered ascending by name" do
      FactoryBot.create(:adjective, name: "passport")
      FactoryBot.create(:adjective, name: "book")
      FactoryBot.create(:adjective, name: "fine")

      result = Adjective.unique_sorted

      expect(result.map(&:name)).to eq(%w[book fine passport])
    end
  end
end
