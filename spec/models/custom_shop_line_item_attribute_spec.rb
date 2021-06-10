require 'rails_helper'

RSpec.describe CustomShopLineItemAttribute, type: :model do

  before do
    @custom_shop_line_item_attribute = build_stubbed(:custom_shop_line_item_attribute)
  end

  subject { @custom_shop_line_item_attribute }
  it { should respond_to(:custom_shop_line_item) }
  it { should respond_to(:customizable_attribute) }
  it { should respond_to(:value) }
end
