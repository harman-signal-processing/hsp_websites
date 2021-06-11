require 'rails_helper'

RSpec.describe BrandDealerRentalProduct, type: :model do
  before do
    @brand_dealer_rental_product = FactoryBot.create(:brand_dealer_rental_product)
  end 
  
  it 'BrandDealerRentalProduct associations should be unique' do
    brand_dealer_rental_product = BrandDealerRentalProduct.new(brand_dealer_id: "#{@brand_dealer_rental_product.brand_dealer_id}", product_id: "#{@brand_dealer_rental_product.product_id}")
	  expect(brand_dealer_rental_product).not_to be_valid
	  expect(brand_dealer_rental_product.errors.messages[:product_id]+brand_dealer_rental_product.errors.messages[:brand_dealer_id]).to include("has already been taken")     
  end 
end  #  RSpec.describe BrandDealerRentalProduct, type: :model do
