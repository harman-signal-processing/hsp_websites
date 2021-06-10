require 'rails_helper'

RSpec.describe CustomShopQuote, type: :model do

  before do
    @custom_shop_quote = build_stubbed(:custom_shop_quote)
  end

  subject { @custom_shop_quote }
  it { should respond_to(:user) }
  it { should respond_to(:custom_shop_line_items) }
end
