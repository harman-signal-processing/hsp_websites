require "minitest_helper"

describe "Admin Pricing Integration Test" do

  before do
    DatabaseCleaner.start
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

  describe "Pricing types list" do 
    before do 
      visit admin_pricing_types_url(host: @website.url, locale: I18n.default_locale)
    end

    it "should list pricing types" do 
      must_have_link @dealer_pricing_type.name, href: admin_pricing_type_path(@dealer_pricing_type, locale: I18n.default_locale)
    end
    
    it "should show which pricing types are included on price list" do
      find(:xpath, "//tr[@id='pricing_type_#{@dealer_pricing_type.id}']").must_have_content "Yes"
      find(:xpath, "//tr[@id='pricing_type_#{@artist_pricing_type.id}']").must_have_content "No"
    end

    it "should have a button to export price list to Excel" do 
      must_have_link "Excel", href: admin_pricing_types_path(format: 'xls', locale: I18n.default_locale)
    end

    # it "should have a button to view price list in browser"
    # it "should have a button to create a PDF price list"
  end

  # describe "Create pricing type" do
  #   before do 
  #     visit admin_pricing_types_url(host: @website.url, locale: I18n.default_locale)
  #     click_on "New Pricing type"
  #   end

  #   it "should have pricing fields" do 
  #     fill_in "pricing_type_name", with: "Dealer Price"
  #     fill_in "pricing_type_name"
  #   end

  #   it "should create a new pricing type for the brand" do
  #     count_all = PricingType.count
  #     fill_in "pricing_type_name", with: "Dealer Price"
  #     click_on "Create"
  #     PricingType.count.must_equal(count_all + 1)
  #     PricingType.last.brand_id.must_equal(@brand.id)
  #   end
  # end

  # describe "Updating prices" do 
  #   before do 
  #     visit admin_pricing_type_url(@dealer_pricing_type, host: @website.url, locale: I18n.default_locale)
  #   end

  #   it "should list current products with a box for each price"
  #   it "should add/update the price for the given product"
  # end

end