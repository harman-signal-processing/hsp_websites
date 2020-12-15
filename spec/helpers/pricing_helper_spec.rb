require "rails_helper"

RSpec.describe PricingHelper do

  describe "calculate_pricing_for_product_page" do
    it "calls calculate_discount_amount" do
      promo = FactoryBot.build_stubbed(:promotion)
      product = FactoryBot.build_stubbed(:product, sale_price: 75.0, street_price: 100.0)

      expect(product).to receive(:calculate_discount_amount).and_return(25.0)
      helper.calculate_pricing_for_product_page(product, promo)
    end

    it "calls calculate_discount_amount" do
      promo = FactoryBot.build_stubbed(:promotion)
      product = FactoryBot.build_stubbed(:product, sale_price: 75.0, street_price: 100.0)

      expect(product).to receive(:calculate_new_price).and_return(75.0)
      helper.calculate_pricing_for_product_page(product, promo)
    end
  end
end
