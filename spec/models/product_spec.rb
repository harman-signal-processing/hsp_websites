require "rails_helper"

RSpec.describe Product, :type => :model do

  before do
	  @digitech = FactoryBot.create(:digitech_brand)
    @product = FactoryBot.build_stubbed(:product)
  end

  subject { @product }
  it { should respond_to(:brand) }
  it { should respond_to(:sap_sku) }
  it { should respond_to(:description) }
  it { should respond_to(:short_description) }
  it { should respond_to(:extended_description) }
  it { should respond_to(:features) }
  it { should respond_to(:legal_disclaimer) }
  it { should respond_to(:product_families) }
  it { should respond_to(:product_videos) }
  it { should respond_to(:badges) }
  it { should respond_to(:product_type) }
  it { should respond_to(:product_keys) }
  it { should respond_to(:available_product_keys) }
  it { should respond_to(:sold_product_keys) }
  it { should respond_to(:digital_ecom?) }

  describe "Product type" do
    it "should default to 'Standard'" do
      standard = FactoryBot.create(:standard_product_type)
      product = FactoryBot.build_stubbed(:product)
      expect(product.product_type.name).to eq(standard.name)
    end
  end

  describe "SKU validation" do
    it "should allow blank SKUs" do
      @product.sap_sku = nil
      expect(@product.valid?).to be(true)
    end

    it "should not allow an email address" do
      @product.sap_sku = "someone@email.com"
      expect(@product.valid?).to be(false)
    end
  end

	describe "dod pedal" do

		before :each do
	  	@dod = FactoryBot.create(:dod_brand)
	  	@product = FactoryBot.create(:product, name: "AB250", brand: @dod)
	  	@pedals = FactoryBot.create(:product_family, brand: @digitech)
	  	FactoryBot.create(:product_family_product, product: @product, product_family: @pedals)
	  end

	  it "should be part of digitech products" do
      expect(@digitech.products).to include(@product)
	  end

  end

  describe "pricing" do
	  before do
	  	@product = FactoryBot.create(:product, brand: @digitech)
  	end

	  it "should determine dealer pricing" do
	  	@dealer_pricing_type = FactoryBot.create(:pricing_type)
	  	@product_price = FactoryBot.create(:product_price, product: @product, pricing_type: @dealer_pricing_type, price_cents: 1999)

      expect(@product.price_for(@dealer_pricing_type).to_f).to eq(19.99)
	  end
  end

  describe "calculate_discount_amount" do

    it "returns 0.0 when there is no promo and no pricing" do
      product = FactoryBot.build_stubbed(:product, sale_price: nil)
      promo = FactoryBot.build_stubbed(:promotion, discount: nil)

      expect(product.calculate_discount_amount(promo)).to eq 0.0
    end

    it "calls calculate_promotion_discount when a valid promo is provided" do
      product = FactoryBot.build_stubbed(:product)
      promo = FactoryBot.build_stubbed(:promotion, discount: 10.0, discount_type: '$')

      expect(product.calculate_discount_amount(promo)).to eq 10.0
    end

    it "calculates discount based on sale price" do
      promo = FactoryBot.build_stubbed(:promotion, discount: nil)
      product = FactoryBot.build_stubbed(:product, sale_price: 75.0, street_price: 100.0)

      expect(product.calculate_discount_amount(promo)).to eq 25.0
    end

    it "calculates discount based on msrp" do
      promo = FactoryBot.build_stubbed(:promotion, discount: nil)
      product = FactoryBot.build_stubbed(:product, sale_price: 75.0, msrp: 100.0)

      expect(product.calculate_discount_amount(promo)).to eq 25.0
    end

    it "returns 0.0 if the sale price is higher than street price" do
      promo = FactoryBot.build_stubbed(:promotion, discount: nil)
      product = FactoryBot.build_stubbed(:product, sale_price: 175.0, street_price: 100.0)

      expect(product.calculate_discount_amount(promo)).to eq 0.0
    end
  end

  describe "calculate_promotion_discount" do
    it "returns 0.0 when the promo doesn't have pricing details" do
      product = FactoryBot.build_stubbed(:product)
      promo = FactoryBot.build_stubbed(:promotion, discount_type: nil)

      expect(product.calculate_promotion_discount(promo)).to eq 0.0
    end

    it "returns 0.0 when the product has no price defined" do
      product = FactoryBot.build_stubbed(:product, street_price: nil, msrp: nil)
      promo = FactoryBot.build_stubbed(:promotion, discount_type: '%', discount: 10.0)

      expect(product.calculate_promotion_discount(promo)).to eq 0.0
    end

    it "returns the dollar amount when the promo type is $" do
      product = FactoryBot.build_stubbed(:product)
      promo = FactoryBot.build_stubbed(:promotion, discount_type: '$', discount: 10.0)

      expect(product.calculate_promotion_discount(promo)).to eq 10.0
    end

    it "returns the percentage of street price" do
      product = FactoryBot.build_stubbed(:product, street_price: 100.0)
      promo = FactoryBot.build_stubbed(:promotion, discount_type: '%', discount: 10.0)

      expect(product.calculate_promotion_discount(promo)).to eq 10.0
    end

    it "returns the percentage of msrp" do
      product = FactoryBot.build_stubbed(:product, msrp: 100.0)
      promo = FactoryBot.build_stubbed(:promotion, discount_type: '%', discount: 20.0)

      expect(product.calculate_promotion_discount(promo)).to eq 20.0
    end
  end

  describe "calculate_new_price" do
    it "returns false if there's no discount" do
      product = FactoryBot.build_stubbed(:product)

      d = product.calculate_new_price(0.0)

      expect(d).to be(false)
    end

    it "returns false if there a discount but no price" do
      product = FactoryBot.build_stubbed(:product, street_price: nil, msrp: nil)

      d = product.calculate_new_price(10.0)

      expect(d).to be(false)
    end

    it "returns street price minus discount" do
      product = FactoryBot.build_stubbed(:product, street_price: 100.0)

      d = product.calculate_new_price(10.0)

      expect(d).to eq(90.0)
    end

    it "returns msrp minus discount" do
      product = FactoryBot.build_stubbed(:product, msrp: 100.0)

      d = product.calculate_new_price(20.0)

      expect(d).to eq(80.0)
    end
  end

  describe "market segments" do
    before do
      @market = FactoryBot.create(:market_segment, brand: @digitech)
      @product_family = FactoryBot.create(:product_family, brand: @digitech)
      @product = FactoryBot.create(:product, brand: @digitech)
      @product_family.products << @product
      @market.product_families << @product_family
    end

    it "is part of market segments" do
      expect(@product.market_segments).to include(@market)
    end
  end

  describe "specifications" do
    before do
      @product_with_specs = FactoryBot.create(:product)
      @spec_group = FactoryBot.create(:specification_group)
      @specification = FactoryBot.create(:specification, specification_group: @spec_group)
      @other_spec = FactoryBot.create(:specification)
      @product_specification = FactoryBot.create(:product_specification, specification: @specification, product: @product_with_specs)
      @other_product_specification = FactoryBot.create(:product_specification, specification: @other_spec, product: @product_with_specs)
    end

    describe "flattened" do

      it "has specs" do
        expect(@product_with_specs.specifications).to include(@specification)
        expect(@product_with_specs.specifications).to include(@other_spec)
      end
    end

    describe "in groups" do

      it "has groups" do
        expect(@product_with_specs.specification_groups).to include(@spec_group)
      end

      it "has un-grouped specs" do
        expect(@product_with_specs.ungrouped_product_specifications).to include(@other_product_specification)
        expect(@product_with_specs.ungrouped_product_specifications).not_to include(@product_specification)
      end

    end
  end
end
