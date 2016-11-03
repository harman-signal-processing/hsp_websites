require "rails_helper"

RSpec.describe Product, :type => :model do

  before do
	  @digitech = FactoryGirl.create(:digitech_brand)
    @product = FactoryGirl.build_stubbed(:product)
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
	  	@dod = FactoryGirl.create(:dod_brand)
	  	@product = FactoryGirl.create(:product, name: "AB250", brand: @dod)
	  	@pedals = FactoryGirl.create(:product_family, brand: @digitech)
	  	FactoryGirl.create(:product_family_product, product: @product, product_family: @pedals)
	  end

	  it "should be part of digitech products" do
      expect(@digitech.products).to include(@product)
	  end

  end

  describe "pricing" do
	  before do
	  	@product = FactoryGirl.create(:product, brand: @digitech)
  	end

	  it "should determine dealer pricing" do
	  	@dealer_pricing_type = FactoryGirl.create(:pricing_type)
	  	@product_price = FactoryGirl.create(:product_price, product: @product, pricing_type: @dealer_pricing_type, price_cents: 1999)

      expect(@product.price_for(@dealer_pricing_type).to_f).to eq(19.99)
	  end
  end

  describe "market segments" do
    before do
      @market = FactoryGirl.create(:market_segment, brand: @digitech)
      @product_family = FactoryGirl.create(:product_family, brand: @digitech)
      @product = FactoryGirl.create(:product, brand: @digitech)
      @product_family.products << @product
      @market.product_families << @product_family
    end

    it "is part of market segments" do
      expect(@product.market_segments).to include(@market)
    end
  end
end
