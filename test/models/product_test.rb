require "test_helper"

describe Product do

  # before :each do
  # 	DatabaseCleaner.start
  # 	Brand.destroy_all
  # end

  # after :each do
  #   DatabaseCleaner.clean
  # end

	describe "dod pedal" do

		before :each do
	  	@dod = FactoryGirl.create(:dod_brand)
	  	@product = FactoryGirl.create(:product, name: "AB250", brand: @dod)
	  	@digitech = FactoryGirl.create(:digitech_brand)
	  	@pedals = FactoryGirl.create(:product_family, brand: @digitech)
	  	FactoryGirl.create(:product_family_product, product: @product, product_family: @pedals)
	  end

	  it "should be part of digitech products" do
	    @digitech.products.must_include(@product)
	  end

  end

  describe "pricing" do
	  before do
	  	@digitech = FactoryGirl.create(:digitech_brand)
	  	@product = FactoryGirl.create(:product, brand: @digitech)
  	end

	  it "should determine dealer pricing" do
	  	@dealer_pricing_type = FactoryGirl.create(:pricing_type)
	  	@product_price = FactoryGirl.create(:product_price, product: @product, pricing_type: @dealer_pricing_type, price_cents: 1999)
	  	@product.price_for(@dealer_pricing_type).to_f.must_equal(19.99)
	  end
  end

end
