require "test_helper"

describe MarketingCalendar do
  before do
    @marketing_calendar = MarketingCalendar.new
  end

  it "must be valid" do
    @marketing_calendar.valid?.must_equal true
  end
end
