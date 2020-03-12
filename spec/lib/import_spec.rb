RSpec.describe Import do
  def import
    Import.new
  end

  describe "channels" do
    it "should return a case insensitive search" do
      expect(import.channel("referral")).not_to be_nil
    end

    it "should error if there is no match" do
      expect {import.channel("non-existing channel")}.to raise_error(RuntimeError)
    end
  end

  describe "devices" do
    it "should return a case insensitive search for a device" do
      expect(import.device("mobile")).not_to be_nil
    end

    it "should error if there is no match" do
      expect {import.device("non-existing device")}.to raise_error(RuntimeError)
    end
  end
end
