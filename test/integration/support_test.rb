require "test_helper"

describe "Support Integration Test" do

  before :each do
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
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

  # NOTE: when migrating to rspec, this section belongs in view specs, not features
    it "should not have other brand products" do
      page.wont_have_xpath("//option[@value='#{@other_product.to_param}']")
    end

  end

end
