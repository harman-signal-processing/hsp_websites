require 'rails_helper'

RSpec.describe CustomShopCart, type: :model do
  before do
    @custom_shop_cart = build_stubbed(:custom_shop_cart)
  end

  subject { @custom_shop_cart }
  it { should respond_to(:custom_shop_line_items) }
end
