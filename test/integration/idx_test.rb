require "minitest_helper"

describe "IDX Integration Test" do

  before do
    DatabaseCleaner.start
    @brand = FactoryGirl.create(:idx_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "pdx", brand: @brand)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  describe "home page" do
    it "should respond with the brand layout" do
      visit root_url(locale: I18n.default_locale, host: @website.url)
      page.must_have_xpath("//div[@id='Header']/div[@id='logo']")
    end
  end

end