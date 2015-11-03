require "rails_helper"

RSpec.describe PricingHelper do

  describe "calculat_pricing_for_product_page" do
    it "calls calculate_discount_amount" do
      promo = FactoryGirl.build_stubbed(:promotion)
      product = FactoryGirl.build_stubbed(:product, sale_price: 75.0, street_price: 100.0)

      expect(helper).to receive(:calculate_discount_amount).and_return(25.0)
      helper.calculate_pricing_for_product_page(product, promo)
    end

    it "calls calculate_discount_amount" do
      promo = FactoryGirl.build_stubbed(:promotion)
      product = FactoryGirl.build_stubbed(:product, sale_price: 75.0, street_price: 100.0)

      expect(helper).to receive(:calculate_new_price).and_return(75.0)
      helper.calculate_pricing_for_product_page(product, promo)
    end
  end

  describe "calculate_discount_amount" do

    it "returns 0.0 when there is no promo and no pricing" do
      product = FactoryGirl.build_stubbed(:product, sale_price: nil)
      promo = FactoryGirl.build_stubbed(:promotion, discount: nil)

      expect(helper.calculate_discount_amount(product, promo)).to eq 0.0
    end

    it "calls calculate_promotion_discount when a valid promo is provided" do
      product = FactoryGirl.build_stubbed(:product)
      promo = FactoryGirl.build_stubbed(:promotion, discount: 10.0, discount_type: '$')

      expect(helper.calculate_discount_amount(product, promo)).to eq 10.0
    end

    it "calculates discount based on sale price" do
      promo = FactoryGirl.build_stubbed(:promotion, discount: nil)
      product = FactoryGirl.build_stubbed(:product, sale_price: 75.0, street_price: 100.0)

      expect(helper.calculate_discount_amount(product, promo)).to eq 25.0
    end

    it "calculates discount based on msrp" do
      promo = FactoryGirl.build_stubbed(:promotion, discount: nil)
      product = FactoryGirl.build_stubbed(:product, sale_price: 75.0, msrp: 100.0)

      expect(helper.calculate_discount_amount(product, promo)).to eq 25.0
    end

    it "returns 0.0 if the sale price is higher than street price" do
      promo = FactoryGirl.build_stubbed(:promotion, discount: nil)
      product = FactoryGirl.build_stubbed(:product, sale_price: 175.0, street_price: 100.0)

      expect(helper.calculate_discount_amount(product, promo)).to eq 0.0
    end
  end

  describe "calculate_promotion_discount" do
    it "returns 0.0 when the promo doesn't have pricing details" do
      product = FactoryGirl.build_stubbed(:product)
      promo = FactoryGirl.build_stubbed(:promotion, discount_type: nil)

      expect(helper.calculate_promotion_discount(product, promo)).to eq 0.0
    end

    it "returns 0.0 when the product has no price defined" do
      product = FactoryGirl.build_stubbed(:product, street_price: nil, msrp: nil)
      promo = FactoryGirl.build_stubbed(:promotion, discount_type: '%', discount: 10.0)

      expect(helper.calculate_promotion_discount(product, promo)).to eq 0.0
    end

    it "returns the dollar amount when the promo type is $" do
      product = FactoryGirl.build_stubbed(:product)
      promo = FactoryGirl.build_stubbed(:promotion, discount_type: '$', discount: 10.0)

      expect(helper.calculate_promotion_discount(product, promo)).to eq 10.0
    end

    it "returns the percentage of street price" do
      product = FactoryGirl.build_stubbed(:product, street_price: 100.0)
      promo = FactoryGirl.build_stubbed(:promotion, discount_type: '%', discount: 10.0)

      expect(helper.calculate_promotion_discount(product, promo)).to eq 10.0
    end

    it "returns the percentage of msrp" do
      product = FactoryGirl.build_stubbed(:product, msrp: 100.0)
      promo = FactoryGirl.build_stubbed(:promotion, discount_type: '%', discount: 20.0)

      expect(helper.calculate_promotion_discount(product, promo)).to eq 20.0
    end
  end

  describe "calculate_new_price" do
    it "returns false if there's no discount" do
      product = FactoryGirl.build_stubbed(:product)

      d = helper.calculate_new_price(product, 0.0)

      expect(d).to be(false)
    end

    it "returns false if there a discount but no price" do
      product = FactoryGirl.build_stubbed(:product, street_price: nil, msrp: nil)

      d = helper.calculate_new_price(product, 10.0)

      expect(d).to be(false)
    end

    it "returns street price minus discount" do
      product = FactoryGirl.build_stubbed(:product, street_price: 100.0)

      d = helper.calculate_new_price(product, 10.0)

      expect(d).to eq(90.0)
    end

    it "returns msrp minus discount" do
      product = FactoryGirl.build_stubbed(:product, msrp: 100.0)

      d = helper.calculate_new_price(product, 20.0)

      expect(d).to eq(80.0)
    end
  end

end
