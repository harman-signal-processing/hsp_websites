require "rails_helper"

RSpec.describe MarketSegment, :type => :model do

  before do
    @market = FactoryGirl.build(:market_segment)
  end

  subject { @market }
  it { should respond_to(:brand) }
  it { should respond_to(:product_families) }
  it { should respond_to(:banner_image) }

end

