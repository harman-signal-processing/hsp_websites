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
