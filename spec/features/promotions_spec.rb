require "rails_helper"

feature "Promotions" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @promo = FactoryBot.create(:promotion, brand: @website.brand)
    @expired_promo = FactoryBot.create(:expired_promotion, brand: @website.brand)
  	@product = @website.products.first
    @product.product_promotions << FactoryBot.create(:product_promotion, promotion: @promo, product: @product)
    @product.product_promotions << FactoryBot.create(:product_promotion, promotion: @expired_promo, product: @product)
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  describe "product page" do
  	before do
      visit product_path(@product, locale: I18n.default_locale)
  	end

  	it "related current promo appears"  do
      expect(page).to have_link @promo.name
    end

  	it "expired promos do not appear" do
  	  expect(page).not_to have_link @expired_promo.name
  	end

    it "should show link to rebate forms" do
      expect(page).to have_link "Rebate Forms", href: promotions_path(locale: I18n.default_locale)
    end

  end

  describe "promo overview page" do

    before do
      visit promotions_path(locale: I18n.default_locale)
    end

  	it "lists current promos" do
      expect(page).to have_link @promo.name, href: promotion_path(@promo, locale: I18n.default_locale)
    end

  	it "does not list expired promos" do
      expect(page).not_to have_content @expired_promo.name
    end

  end

end
