require "rails_helper"

feature "Promotions" do

  before :all do
    @website = FactoryGirl.create(:website_with_products)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @promo = FactoryGirl.create(:promotion, brand: @website.brand)
    @expired_promo = FactoryGirl.create(:expired_promotion, brand: @website.brand)
    @recently_expired_promo = FactoryGirl.create(:recently_expired_promotion, brand: @website.brand)
  	@product = @website.products.first
    @product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @promo, product: @product)
    @product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @expired_promo, product: @product)
  end

  after :all do
    DatabaseCleaner.clean_with(:truncation)
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

  describe "product page when promo is recently expired" do
    it "should show link to rebate forms" do
      product = @website.products.last
      product.product_promotions << FactoryGirl.create(:product_promotion, promotion: @recently_expired_promo, product: product)

      visit product_path(product, locale: I18n.default_locale)

      expect(page).to have_link "Rebate Forms", href: promotions_path(locale: I18n.default_locale)
    end
  end

  describe "promo overview page" do

    before do
      visit promotions_path(locale: I18n.default_locale)
    end

  	it "lists current promos" do
      expect(page).to have_link I18n.t(:download_promotion_form), href: @promo.promo_form.url
    end

    it "links to recently expired promotion" do
      expect(page).to have_link I18n.t(:download_promotion_form), href: @recently_expired_promo.promo_form.url
    end

  	it "does not list expired promos" do
      expect(page).not_to have_content @expired_promo.name
    end

  end

end
