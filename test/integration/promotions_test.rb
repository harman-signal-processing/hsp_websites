require "minitest_helper"

describe "Promotions Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
    @promo = FactoryGirl.create(:promotion, brand: @website.brand)
    @expired_promo = FactoryGirl.create(:expired_promotion, brand: @website.brand)
    @recently_expired_promo = FactoryGirl.create(:recently_expired_promotion, brand: @website.brand)
  	@product = @website.products.first
    @product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @promo, product: @product)
    @product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @expired_promo, product: @product)
  end

  after :each do
    DatabaseCleaner.clean
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

    it "should show link to rebate forms" do 
      must_have_link "Rebate Forms", href: promotions_path(locale: I18n.default_locale)
    end

  end

  describe "product page when promo is recently expired" do 
    it "should show link to rebate forms" do 
      product = @website.products.last
      product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @recently_expired_promo, product: product)
      visit product_url(product, locale: I18n.default_locale, host: @website.url)
      must_have_link "Rebate Forms", href: promotions_path(locale: I18n.default_locale)
    end
  end

  describe "promo overview page" do

    before do 
      visit promotions_url(locale: I18n.default_locale, host: @website.url)
    end

  	it "lists current promos" do 
      must_have_link I18n.t(:download_promotion_form), href: @promo.promo_form.url
    end

    it "links to recently expired promotion" do 
      must_have_link I18n.t(:download_promotion_form), href: @recently_expired_promo.promo_form.url
    end

  	it "does not list expired promos" do 
      wont_have_content @expired_promo.name
    end

  end

end