require 'rails_helper'

RSpec.describe SalesOrder, type: :model do
  before(:all) do
    @sales_order = FactoryBot.build_stubbed(:sales_order)
  end

  subject { @sales_order }
  it { should respond_to(:line_items) }
  it { should respond_to(:user) }
  it { should respond_to(:shopping_cart) }
  it { should respond_to(:tax) }
  it { should respond_to(:total) }

  it "should format an order number" do
    brand = FactoryBot.build_stubbed(:brand, name: "Lexicon")

    expect(@sales_order).to receive(:brand).and_return(brand)
    expect(@sales_order).to receive(:id).and_return(321)
    expect(@sales_order).to receive(:created_at).and_return("2021-01-01".to_time)

    expect(@sales_order.number).to eq("LEX02100321")
  end

  it "should get the brand from the first line item" do
    brand = FactoryBot.build_stubbed(:brand, name: "Lexicon")
    product = FactoryBot.build_stubbed(:product, brand: brand)
    line_item = FactoryBot.build_stubbed(:line_item, product: product)

    expect(@sales_order).to receive(:line_items).and_return([line_item])
    expect(@sales_order.brand).to eq(brand)
  end

  describe "creating an order" do
    it "should the line items from the cart to the sales_order" do
      shopping_cart = FactoryBot.create(:shopping_cart)
      line_item = FactoryBot.create(:line_item, price_cents: 50000, shopping_cart: shopping_cart)

      sales_order = FactoryBot.create(:sales_order, shopping_cart: shopping_cart)

      line_item.reload
      expect(line_item.sales_order_id).to eq(sales_order.id)
    end
  end
end
