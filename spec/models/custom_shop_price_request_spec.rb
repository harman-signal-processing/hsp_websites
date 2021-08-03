require 'rails_helper'

RSpec.describe CustomShopPriceRequest, type: :model do

  before do
    @custom_shop_price_request = build_stubbed(:custom_shop_price_request)
  end

  subject { @custom_shop_price_request }
  it { should respond_to(:user) }
  it { should respond_to(:status) }
  it { should respond_to(:custom_shop_line_items) }
  it { should respond_to(:total) }

  it "should format a price request number" do
    brand = FactoryBot.build_stubbed(:brand, name: "JBL Professional")

    expect(@custom_shop_price_request).to receive(:brand).and_return(brand)
    expect(@custom_shop_price_request).to receive(:id).and_return(456)
    expect(@custom_shop_price_request).to receive(:created_at).and_return("2021-01-01".to_time)

    expect(@custom_shop_price_request.number).to eq("JBLCS2100456")
  end
end
