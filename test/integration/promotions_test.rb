require "minitest_helper"

describe "Promotions Integration Test" do

  before do
    DatabaseCleaner.start
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
    @promo = FactoryGirl.create(:promotion, brand: @website.brand)
    @expired_promo = FactoryGirl.create(:expired_promotion, brand: @website.brand)
  	@product = @website.products.first
    @product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @promo, product: @product)
    @product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @expired_promo, product: @product)
  end
  
  describe "product page" do
  	before do
      visit product_url(@product, locale: I18n.default_locale, host: @website.url)  	  
  	end

  	it "related current promo appears"  do 
      page.must_have_link @promo.name
    end

  	it "expired promos do not appear" do
  	  page.wont_have_link @expired_promo.name
  	end

  end

  describe "promo overview page" do

  	it "lists current promos"
  	it "does not list expired promos"

  end

end