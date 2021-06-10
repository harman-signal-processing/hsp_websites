require 'rails_helper'

RSpec.describe CustomShopLineItem, type: :model do

  before do
    @custom_shop_line_item = build_stubbed(:custom_shop_line_item)
  end

  subject { @custom_shop_line_item }
  it { should respond_to(:custom_shop_cart) }
  it { should respond_to(:custom_shop_quote) }
  it { should respond_to(:product) }
  it { should respond_to(:custom_shop_line_item_attributes) }
end
