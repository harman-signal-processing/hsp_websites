require "minitest_helper"

describe "Support Integration Test" do

  before do
    DatabaseCleaner.start
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "Contact form" do
  	before do
  	  visit support_url(locale: I18n.default_locale, host: @website.url)
  	end

  	it "should have fields and submit" do
  	  select ContactMessage.subjects.last[0], from: "contact_message_subject"
  	  fill_in "contact_message_name", with: "Joe"
  	  fill_in "contact_message_email", with: "joe@joe.com"
  	  select @website.products.first.name, from: "contact_message_product"
  	  fill_in "contact_message_product_serial_number", with: "12345"
  	  fill_in "contact_message_operating_system", with: "Lion"
  	  fill_in "contact_message_shipping_address", with: "123 Anywhere"
  	  fill_in "contact_message_shipping_country", with: "Naboo"
  	  fill_in "contact_message_phone", with: "555-5555"
  	  fill_in "contact_message_message", with: "Hi Dean. How are you?"
  	  click_on "submit"
  		# save_and_open_page
  	  current_path.must_equal support_path(locale: I18n.default_locale)
  	end
  end

  describe "Product dropdown" do
    before do
      other_brand = FactoryGirl.create(:brand)
      @other_product = FactoryGirl.create(:discontinued_product, brand: other_brand)
      @product = FactoryGirl.create(:discontinued_product, brand: @website.brand)
      visit support_url(locale: I18n.default_locale, host: @website.url)
    end

    it "should have discontinued product" do
      select @product.name, from: "product_id"
      click_on "go"
      current_path.must_equal product_path(@product, locale: I18n.default_locale)
    end

    it "should not have other brand products" do
      page.wont_have_xpath("//option[@value='#{@other_product.to_param}']")
    end

  end

end