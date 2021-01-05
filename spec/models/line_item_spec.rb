require 'rails_helper'

RSpec.describe LineItem, type: :model do

  before(:all) do
    @line_item = FactoryBot.build_stubbed(:line_item)
  end

  subject { @line_item }
  it { should respond_to(:shopping_cart) }
  it { should respond_to(:sales_order) }
  it { should respond_to(:price) }

  describe "pricing" do
    before(:all) do
      @shopping_cart = FactoryBot.create(:shopping_cart)
    end

    it "should initialize with msrp" do
      product = FactoryBot.create(:product, msrp: 500.00, street_price: nil, sale_price: nil)
      line_item = @shopping_cart.add_item(product)

      expect(product.price_for_shopping_cart).to eq(product.msrp)
      expect(line_item.price).to eq(product.msrp)
    end

    it "should initialize with street_price" do
      product = FactoryBot.create(:product, msrp: 500.00, street_price: 400.00, sale_price: nil)
      line_item = @shopping_cart.add_item(product)

      expect(product.price_for_shopping_cart).to eq(product.street_price)
      expect(line_item.price).to eq(product.street_price)
    end

    it "should initialize with sale_price" do
      product = FactoryBot.create(:product, msrp: 500.00, street_price: 400.00, sale_price: 300.00)
      line_item = @shopping_cart.add_item(product)

      expect(product.price_for_shopping_cart.to_f).to eq(product.sale_price.to_f)
      expect(line_item.price).to eq(product.sale_price)
    end

    it "should initialize with a promotional price" do
      product = FactoryBot.create(:product, street_price: 400.00)
      FactoryBot.create(:product_promotion,
                        product: product,
                        discount: 10.0,
                        discount_type: '$')

      line_item = @shopping_cart.add_item(product)
      expect(line_item.price.to_f).to eq(390.00)
    end
  end

  describe "assigning product keys" do
    it "should assign a product key when saving if it has had an order assigned" do
      shopping_cart = FactoryBot.create(:shopping_cart)
      product = FactoryBot.create(:product)
      product_key = FactoryBot.create(:product_key, product: product)
      line_item = FactoryBot.create(:line_item, price_cents: 100, product: product)

      expect(product).to receive(:digital_ecom?).and_return(true)
      expect(shopping_cart).to receive(:line_items).and_return([line_item])
      sales_order = FactoryBot.create(:sales_order, shopping_cart: shopping_cart)

      product_key.reload
      expect(product_key.line_item_id).to eq(line_item.id)
      expect(product_key.user_id).to eq(sales_order.user_id)
    end
  end
end
