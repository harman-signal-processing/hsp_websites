require "rails_helper"

feature "Support Landing Page" do

  before :all do
    @website = FactoryBot.create(:website)
    @product = FactoryBot.create(:discontinued_product, brand: @website.brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  before :each do
    visit support_path(locale: I18n.default_locale)
  end

  describe "Product dropdown" do

    it "should have discontinued product" do
      select @product.name, from: "product_id"
      click_on "go"

      expect(current_path).to eq product_path(@product, locale: I18n.default_locale)
    end

  end

end
