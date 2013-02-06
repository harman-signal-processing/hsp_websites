require "minitest_helper"

describe DealerUser do
  # fixtures :all

  before do
    @dealer_user = DealerUser.new
  end

  it "must be valid" do
    @dealer_user.must_be :valid?
  end

  it "must be a real test" do
    skip "Write dealer-user tests"
    flunk "Need real tests"
  end
end
