require "rails_helper"

feature "Special product browsing for Martin" do

  before :all do
    @website = FactoryBot.create(:website, folder: 'martin')
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "discontinued products" do
    let(:product) { create(:discontinued_product, brand: @website.brand) }
    let(:product_family) { create(:product_family, brand: @website.brand) }

    it "appears in dropdown an can be navigated to" do
      product_family.products << product

      visit discontinued_products_path(locale: I18n.default_locale)

      select product.name, from: "product_id"
      click_on 'Go'

      expect(page.current_path).to eq(product_path(product, locale: I18n.default_locale))
    end
  end

  describe "photometrics" do
    let(:product) { create(:product, brand: @website.brand, photometric_id: "12345") }

    it "should render the photometric iframe" do
      visit photometric_product_path(product, locale: I18n.default_locale)

      expect(page).to have_content("Photometric report")
    end

    it "should redirect to the product path if no photometric_id present" do
      product.update(photometric_id: nil)

      visit photometric_product_path(product, locale: I18n.default_locale)

      expect(page.current_path).to eq(product_path(product, locale: I18n.locale))
    end
  end

  describe "BOM" do
    let(:product) { create(:product, brand: @website.brand) }
    let(:part) { create(:part) }

    it "should show the bill of materials" do
      product.parts << part
      @user = create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
      admin_login_with(@user.email, "password", @website)

      visit bom_product_path(product, locale: I18n.default_locale)

      expect(page).to have_content(part.part_number)
    end

    it "should redirect unauthorized users" do
      visit bom_product_path(product, locale: I18n.default_locale)

      expect(page.current_path).to eq(product_path(product, locale: I18n.default_locale))
      expect(page).to have_content("access denied")
    end
  end
end

