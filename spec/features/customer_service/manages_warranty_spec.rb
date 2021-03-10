require "rails_helper"

feature "Managing warranty periods", :devise do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  scenario "Update product warranty periods successfully" do
    user = FactoryBot.create(:user, customer_service: true, password: "password", confirmed_at: 1.minute.ago)
    admin_login_with(user.email, "password", @website)
    visit warranty_policy_path

    product1 = create(:product, brand: @website.brand, warranty_period: 1)
    product2 = create(:product, brand: @website.brand, warranty_period: nil)
    product3 = create(:product, brand: @website.brand, warranty_period: 5)
    product4 = create(:product, brand: @website.brand, warranty_period: 5)

    click_on "Manage Warranty Periods"
    expect(current_path).to eq edit_warranty_products_path(locale: I18n.default_locale)

    fill_in "product_attr[#{product1.id}]", with: "2"
    fill_in "product_attr[#{product4.id}]", with: ""
    click_on "Update"

    expect(current_path).to eq warranty_policy_path(locale: I18n.default_locale)
    product1.reload
    expect(product1.warranty_period).to eq(2) # updated 1 -> 2
    product2.reload
    expect(product2.warranty_period).to eq(nil) # unchanged nil value
    product3.reload
    expect(product3.warranty_period).to eq(5) # unchanged value
    product4.reload
    expect(product4.warranty_period).to eq(nil) # updated 5 -> nil
  end

  scenario "unsuccessfully (no access)" do
    user = FactoryBot.create(:user, password: "password", confirmed_at: 1.minute.ago)
    admin_login_with(user.email, "password", @website)
    visit warranty_policy_path

    expect(page).not_to have_link("Manage Warranty Periods")

    visit edit_warranty_products_path(locale: I18n.default_locale)
    expect(current_path).not_to eq(edit_warranty_products_path(locale: I18n.default_locale))
  end
end

