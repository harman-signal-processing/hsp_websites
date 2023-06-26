require "rails_helper"

feature "Browse Product Selector" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "start page" do
    it "loads top-level product categories" do
      product_family = @website.product_families.first

      visit product_selector_path

      expect(page).to have_link(product_family.name, href: product_selector_product_family_path(product_family, locale: I18n.default_locale))
    end
  end

  describe "clicking through to a family page" do
    it "shows the products to be filtered" do
      product_family = @website.product_families.first
      product = product_family.products.first

      visit product_selector_path
      click_on product_family.name

      expect(page).to have_link(product.name, href: product_path(product, locale: I18n.default_locale))
    end
  end

  describe "loading the family page directly" do
    it "shows the products to be filtered" do
      product_family = @website.product_families.first
      product = product_family.products.first

      visit product_selector_product_family_path(product_family, locale: I18n.default_locale)

      expect(page).to have_link(product.name, href: product_path(product, locale: I18n.default_locale))
    end
  end

  describe "loading a sub-family page directly" do
    it "shows the products" do
      product_family = @website.product_families.first
      sub_family = create(:product_family, brand: @website.brand, parent: product_family)
      product = create(:product, brand: @website.brand)
      sub_family.products << product

      visit product_selector_product_family_path(product_family, locale: I18n.default_locale)
      expect(page).to have_link(sub_family.name)

      visit product_selector_subfamily_product_selector_product_family_path(product_family, sub_family, locale: I18n.default_locale)

      expect(page).to have_link(product.name, href: product_path(product, locale: I18n.default_locale))
    end
  end

end
