require "test_helper"

describe "Admin Pricing Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, url: "digitech.lvh.me")
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
    @user = FactoryGirl.create(:user, market_manager: true, password: "password")
    admin_login_with(@user, "password", @website)
    @dealer_pricing_type = FactoryGirl.create(:pricing_type, brand: @brand, pricelist_order: 1)
    @artist_pricing_type = FactoryGirl.create(:pricing_type, brand: @brand, pricelist_order: 0)
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "Pricing types list" do 
    before do 
      visit admin_pricing_types_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should list pricing types" do 
      must_have_link @dealer_pricing_type.name, href: edit_admin_pricing_type_path(@dealer_pricing_type, locale: I18n.default_locale)
    end
    
    it "should show which pricing types are included on price list" do
      find(:xpath, "//tr[@id='pricing_type_#{@dealer_pricing_type.id}']").must_have_content "Yes"
      find(:xpath, "//tr[@id='pricing_type_#{@artist_pricing_type.id}']").must_have_content "No"
    end

  end

  describe "Create pricing type" do
    before do 
      visit admin_pricing_types_url(host: @website.url, locale: I18n.default_locale)
      click_on "New Pricing type"
    end

    it "should have pricing fields" do 
      fill_in "pricing_type_name", with: "Dealer Price"
      select '1', from: "pricing_type_pricelist_order"
    end

    it "should create a new pricing type for the brand" do
      count_all = PricingType.count
      fill_in "pricing_type_name", with: "Dealer Price"
      click_on "Create"
      PricingType.count.must_equal(count_all + 1)
      PricingType.last.brand_id.must_equal(@brand.id)
    end
  end

  describe "Updating prices" do 
    before do 
      @product = @website.products.first
      @product_price = FactoryGirl.create(:product_price, product: @product, pricing_type: @dealer_pricing_type, price: 200.99)
      @product_price = FactoryGirl.create(:product_price, product: @product, pricing_type: @artist_pricing_type, price: 199.95)
      visit admin_product_prices_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should add/update the price for the given product" do 
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[0]][price]", with: "19.99"
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[1]][price]", with: "19.99"
      click_on "save changes"
      @product.price_for(@dealer_pricing_type).must_equal(19.99)
      @product.price_for(@artist_pricing_type).must_equal(19.99)
    end
  end

  describe "Product prices overview" do 
    before do 
      visit admin_product_prices_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should have a button to export price list to Excel" do 
      must_have_link "Excel", href: admin_product_prices_path(loc: "us", format: 'xls', locale: I18n.default_locale)
      must_have_link "Excel", href: admin_product_prices_path(loc: "intl", format: 'xls', locale: I18n.default_locale)
    end

    it "should have a form to update prices" do 
      must_have_field "product_attr[#{@website.products.first.to_param}][msrp]"
    end

    it "should have fields to update the pricing type values" do 
      must_have_field "product_attr[#{@website.products.first.to_param}][product_prices_attributes[0]][price]"
    end

    it "should update the price" do 
      @product = @website.products.first
      fill_in "product_attr[#{@product.to_param}][msrp]", with: "199.99"
      fill_in "product_attr[#{@product.to_param}][street_price]", with: "99.99"
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[0]][price]", with: "19.99"
      fill_in "product_attr[#{@product.to_param}][product_prices_attributes[1]][price]", with: "19.99"
      click_on "save changes"
      @product.reload
      @product.msrp.must_equal(199.99)
      @product.street_price.must_equal(99.99)
      @product.price_for(@dealer_pricing_type).must_equal(19.99)
    end
  end

end