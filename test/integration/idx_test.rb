require "test_helper"

describe "IDX Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @brand = FactoryGirl.create(:idx_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "idx", brand: @brand)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "home page" do
    it "should respond with the brand layout" do
      visit root_url(locale: I18n.default_locale, host: @website.url)
      page.must_have_xpath("//body[@data-brand='#{@brand.name}']")
    end
  end

end