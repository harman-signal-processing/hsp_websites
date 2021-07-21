require 'rails_helper'

RSpec.describe CustomShopQuote, type: :model do

  before do
    @custom_shop_quote = build_stubbed(:custom_shop_quote)
  end

  subject { @custom_shop_quote }
  it { should respond_to(:user) }
  it { should respond_to(:status) }
  it { should respond_to(:custom_shop_line_items) }
  it { should respond_to(:total) }

  it "should format a quote number" do
    brand = FactoryBot.build_stubbed(:brand, name: "JBL Professional")

    expect(@custom_shop_quote).to receive(:brand).and_return(brand)
    expect(@custom_shop_quote).to receive(:id).and_return(456)
    expect(@custom_shop_quote).to receive(:created_at).and_return("2021-01-01".to_time)

    expect(@custom_shop_quote.number).to eq("JBLCS2100456")
  end
end
