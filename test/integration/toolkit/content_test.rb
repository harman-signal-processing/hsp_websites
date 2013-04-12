require "test_helper"

describe "Toolkit Content Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    setup_toolkit_brands
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url 
    host! @host
    Capybara.default_host = "http://#{@host}" 
    Capybara.app_host = "http://#{@host}" 
    Dealer.any_instance.stubs(:geocode_address)
    setup_and_login_toolkit_dealer
  end

  after :each do
    DatabaseCleaner.clean
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

  describe "products list page" do 
    before do
      @brand = Brand.last
      @product = @brand.toolkit_products.first
    end 

    it "index should link to product" do
      visit toolkit_brand_products_url(@brand, host: @host)
      must_have_link @product.name, href: toolkit_brand_product_path(@brand, @product, locale: I18n.default_locale)
    end

    it "should include products which are announced but not yet in production" do 
      announced = FactoryGirl.create(:product_status, shipping: false)
      @product.product_status = announced
      @product.save
      visit toolkit_brand_products_url(@brand, host: @host)
      must_have_link @product.name
    end

    it "should NOT include products which are in development" do 
      in_development = FactoryGirl.create(:product_status, shipping: false, show_on_website: false)
      @product.product_status = in_development
      @product.save
      visit toolkit_brand_products_url(@brand, host: @host)
      wont_have_link @product.name
    end

    it "should NOT link to discontinued products" do 
      discontinued = FactoryGirl.create(:product_status, shipping: false, discontinued: true)
      @product.product_status = discontinued
      @product.save
      visit toolkit_brand_products_url(@brand, host: @host)
      wont_have_link @product.name
    end      
  end

  describe "product family page" do 
    before do 
      @brand = Brand.last
      @product = @brand.toolkit_products.first
      @product_family = FactoryGirl.create(:product_family, brand: @brand)
    end

    # it "should organize by sub-families"

    it "should link to current products" do 
      FactoryGirl.create(:product_family_product, product: @product, product_family: @product_family)  
      visit toolkit_brand_product_family_url(@brand, @product_family, host: @host)
      page.must_have_link @product.name
    end

    it "should link to announced products" do
      announced = FactoryGirl.create(:product_status, shipping: false) 
      @announced_product = FactoryGirl.create(:product, brand: @brand, product_status: announced)
      FactoryGirl.create(:product_family_product, product: @announced_product, product_family: @product_family)

      visit toolkit_brand_product_family_url(@brand, @product_family, host: @host)
      page.must_have_link @announced_product.name
    end

    it "should NOT link to products in-development" do 
      in_development = FactoryGirl.create(:product_status, shipping: false, show_on_website: false)
      @developing_product = FactoryGirl.create(:product, brand: @brand, product_status: in_development)
      FactoryGirl.create(:product_family_product, product: @developing_product, product_family: @product_family)

      visit toolkit_brand_product_family_url(@brand, @product_family, host: @host)
      page.wont_have_link @developing_product.name
    end

    it "should link to discontinued products at the bottom" do 
      discontinued = FactoryGirl.create(:product_status, shipping: false, discontinued: true)
      @discontinued_product = FactoryGirl.create(:product, brand: @brand, product_status: discontinued)
      FactoryGirl.create(:product_family_product, product: @discontinued_product, product_family: @product_family)

      visit toolkit_brand_product_family_url(@brand, @product_family, host: @host)
      page.must_have_content "Discontinued"
      page.must_have_link @discontinued_product.name
    end

  end

  describe "current product pages" do
    before do
      @brand = Brand.last
      @product = FactoryGirl.create(:product, brand: @brand)
      visit toolkit_brand_product_url(@brand, @product, host: @host)
    end

    it "should have product content" do
      must_have_content @product.description
    end
  end

  describe "discontinued product pages" do
    before do
      @brand = Brand.last
      @product = FactoryGirl.create(:product, brand: @brand)
      discontinued = FactoryGirl.create(:product_status, shipping: false, discontinued: true)
      @discontinued_product = FactoryGirl.create(:product, brand: @brand, product_status: discontinued)
      visit toolkit_brand_product_url(@brand, @discontinued_product, host: @host)
    end

    it "should have product content" do
      must_have_content @discontinued_product.description
    end

    it "should clearly identify the product as discontinued" do
      must_have_content "This product has been discontinued"
    end

    # it "should offer a suggested replacement"
  end

  describe "announced product pages" do
    before do
      @brand = Brand.last
      @product = FactoryGirl.create(:product, brand: @brand)
      announced = FactoryGirl.create(:product_status, shipping: false) 
      @product.product_status = announced
      @product.save
      visit toolkit_brand_product_url(@brand, @product, host: @host)
    end

    it "should have product content" do
      must_have_content @product.description
    end

    it "should identify the product as not-shipping yet" do 
      must_have_content "subject to change"
    end
    
  end

  def setup_and_login_toolkit_dealer
    @dealer = FactoryGirl.create(:dealer)
    @password = "pass123"
    @user = FactoryGirl.create(:user, 
      dealer: true, 
      account_number: @dealer.account_number, 
      password: @password, 
      password_confirmation: @password)
    @user.confirm!
    visit new_toolkit_user_session_url(host: @host)
    fill_in :toolkit_user_email, with: @user.email
    fill_in :toolkit_user_password, with: @password
    click_on "Sign in"
  end

end