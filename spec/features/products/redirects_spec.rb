require "rails_helper"

feature "Product redirects" do

  before :all do
    @website = FactoryBot.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "stored in product.product_page_url" do
    let(:product2) { create(:product, brand: @website.brand) }
    let(:product) { create(:product, brand: @website.brand, product_page_url: "http://#{@website.url}/#{I18n.default_locale}/products/#{ product2.to_param }") }
    it "redirects" do
      visit product_path(product, locale: I18n.default_locale)

      expect(page.current_url).to eq(product.product_page_url)
    end

    it "avoids circular redirects" do
      product2.update( product_page_url: "http://#{@website.url}/#{I18n.default_locale}/products/#{ product2.to_param }" )

      visit product_path(product2, locale: I18n.default_locale)

      expect(page.current_path).to eq(product_path(product2, locale: I18n.default_locale))
    end
  end

  describe "brand configured to redirect links to parent brand's site" do
    let(:other_brand) { create(:brand) }
    let(:other_website) { create(:website, brand: other_brand) }
    let(:other_product) { create(:product, brand: other_brand) }
    let(:product_family) { create(:product_family, brand: @website.brand) }

    it "redirects product pages to the product's brand" do
      @website.brand.update(redirect_product_pages_to_parent_brand: true, default_website_id: other_website.id)
      product_family.products << other_product

      visit product_path(other_product, locale: I18n.default_locale)

      expect(page.current_url).to eq("http://#{other_website.url}/#{I18n.default_locale}/products/#{other_product.to_param}")
    end
  end
end
