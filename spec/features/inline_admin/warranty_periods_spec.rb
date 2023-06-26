require "rails_helper"

feature "Editing warranty periods" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
  end

  describe "successfully" do
    it "updates the warranty period" do
      admin_login_with(@user.email, "password", @website)
      visit warranty_policy_path(locale: I18n.default_locale)
      expect(page).not_to have_content("25 years")

      visit edit_warranty_products_path(locale: I18n.default_locale)
      fill_in "product_attr_#{@website.products.first.id}", with: 25
      click_on "Update"

      visit warranty_policy_path(locale: I18n.default_locale)
      expect(page).to have_content("25 years")
    end
  end

  describe "unauthorized" do
    it "shows an error" do
      visit edit_warranty_products_path(locale: I18n.default_locale)

      expect(page.current_path).to eq(new_user_session_path(locale: I18n.default_locale))
      expect(page).to have_content("sign in or sign up before continuing")
    end
  end
end

