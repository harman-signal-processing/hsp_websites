require "rails_helper"

feature "Preview product page" do

  before :all do
    @website = create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "with a pre-defined password" do
    let(:product) { create(:secret_product, brand: @website.brand, password: "Password123") }

    it "should be successful with the correct password" do
      visit product_path(product, locale: I18n.locale)

      expect(page.current_path).to eq(preview_product_path(product, locale: I18n.locale))

      fill_in :password, with: product.password
      fill_in :email, with: "johnny@test.com"
      click_on :continue

      expect(page.current_path).to eq(product_path(product, locale: I18n.locale))
      product.reload
      expect(product.previewers).to include("johnny@test.com")
    end

    it "should fail with the wrong password" do
      visit product_path(product, locale: I18n.locale)

      expect(page.current_path).to eq(preview_product_path(product, locale: I18n.locale))

      fill_in :password, with: "not-the-password"
      fill_in :email, with: "sneaky@pete.com"
      click_on :continue

      expect(page).to have_content("Please check the password")
      expect(page.current_path).not_to eq(product_path(product, locale: I18n.locale))
      product.reload
      expect(product.previewers).not_to include("sneaky@pete.com")
    end
  end

  describe "without a password" do
    let(:product) { create(:secret_product, brand: @website.brand) }

    it "should show an error" do
      visit product_path(product, locale: I18n.locale)

      expect(page).to have_content("Not available")
    end
  end
end


