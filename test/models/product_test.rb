require "minitest_helper"

describe Product do 

	describe "hardwire pedal" do
  
	  before do
	  	@hardwire = FactoryGirl.create(:hardwire_brand)
	  	@product = FactoryGirl.create(:product, name: "EZ-7", brand: @hardwire) 
	  	@digitech = FactoryGirl.create(:digitech_brand)
	  	@pedals = FactoryGirl.create(:product_family, brand: @digitech)
	  	FactoryGirl.create(:product_family_product, product: @product, product_family: @pedals)
	  end

	  it "should be part of digitech products" do
	    @digitech.products.must_include(@product)
	  end

  	end
  
end