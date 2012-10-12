require "minitest_helper"

describe "Toolkit Integration Test" do

  before do
    DatabaseCleaner.start
    setup_toolkit_brands
    @host = "test.toolkit.lvh.me"
    host! @host
    Capybara.default_host = "http://#{@host}" 
    Capybara.app_host = "http://#{@host}" 
  end
  
  describe "homepage" do
    before do
      visit toolkit_root_url(host: @host)
    end

  	it "should use the toolkit layout" do	
  		must_have_content "Marketing Toolkit"
  	end

    it "should link to brand pages" do
      brand = Brand.last
      must_have_link brand.name, href: toolkit_brand_path(brand, locale: I18n.default_locale)
    end
  end

  describe "devise user accounts" do
  	it "should use the toolkit layout" do
  		visit new_user_session_url(host: @host)
  		must_have_content "Marketing Toolkit"
  	end
  end

  describe "brand page" do
    before do
      @brand = Brand.last
      visit toolkit_brand_url(@brand, host: @host)
    end

    it "should use the toolkit layout" do
      must_have_content "Marketing Toolkit"
    end

    it "should have links to products" do
      must_have_link "Products", href: toolkit_brand_products_path(@brand, locale: I18n.default_locale)
    end

    it "should have links to promotions" do
      must_have_link "Promotions", href: toolkit_brand_promotions_path(@brand, locale: I18n.default_locale)
    end
  end

  describe "product pages" do
    before do
      @brand = Brand.last
      @product = FactoryGirl.create(:product, brand: @brand)
      visit toolkit_brand_product_url(@brand, @product, host: @host)
    end

    it "index should link to product" do
      must_have_link @product.name, href: toolkit_brand_product_path(@brand, @product, locale: I18n.default_locale)
    end
  end


end