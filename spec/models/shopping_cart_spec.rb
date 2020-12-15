require 'rails_helper'

RSpec.describe ShoppingCart, type: :model do

  before do
    @shopping_cart = FactoryBot.create(:shopping_cart)
  end

  subject { @shopping_cart }
  it { should respond_to(:line_items) }

  it "should add an item" do
    product = FactoryBot.create(:product)
    @shopping_cart.add_item(product)
    @shopping_cart.reload

    expect(@shopping_cart.empty?).to be(false)
    expect(@shopping_cart.line_items.first.product).to eq(product)
  end

  it "should increment quantity when adding an item that is already in the cart" do
    product = FactoryBot.create(:product)
    @shopping_cart.add_item(product)
    @shopping_cart.add_item(product)
    @shopping_cart.reload

    expect(@shopping_cart.line_items.first.quantity).to eq(2)
  end
end
