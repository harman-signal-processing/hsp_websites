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

  it "should remove an item" do
    product = FactoryBot.create(:product)
    FactoryBot.create(:line_item, shopping_cart: @shopping_cart, product: product, price: 1000)
    @shopping_cart.remove_item(product)

    expect(@shopping_cart.empty?).to be(true)
  end

  it "should increment quantity when adding an item that is already in the cart" do
    product = FactoryBot.create(:product)
    @shopping_cart.add_item(product)
    @shopping_cart.add_item(product)
    @shopping_cart.reload

    expect(@shopping_cart.line_items.last.quantity).to eq(2)
  end

  it "should calculate total items" do
    product = FactoryBot.create(:product)
    product2 = FactoryBot.create(:product)
    @shopping_cart.add_item(product)
    @shopping_cart.add_item(product)
    @shopping_cart.add_item(product2)
    @shopping_cart.reload

    expect(@shopping_cart.total_items).to eq(3)
  end

end
