require "spec_helper"

RSpec.describe Verb, type: :model do
  describe "unique verbs" do
    it "should get unique verbs ordered ascending by name" do
      FactoryBot.create(:verb, name: "find")
      FactoryBot.create(:verb, name: "apply")
      FactoryBot.create(:verb, name: "renew")

      result = Verb.unique_sorted

      expect(result.map(&:name)).to eq(%w[apply find renew])
    end
  end
end
