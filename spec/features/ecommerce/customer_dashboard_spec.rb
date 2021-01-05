require "rails_helper"

feature "User logs in to see purchased product keys" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    @brand = @website.brand
    FactoryBot.create(:product_types)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @product = @brand.products.first
    @product.update(
      product_type: ProductType.digital_ecom,
      msrp: 500, street_price: 123.99
    )
    @user = FactoryBot.create(:user, password: "password", confirmed_at: 1.week.ago)
    @shopping_cart = create(:shopping_cart)
    @line_item = create(:line_item, price: 12399, product: @product, shopping_cart: @shopping_cart)
    @sales_order = create(:sales_order, user: @user, shopping_cart: @shopping_cart)
    @product_key = create(:product_key, product: @product, user: @user, line_item: @line_item)
  end

  before :each do
    signin(@user.email, "password")
    visit profile_path
  end

  # Right now the logged in user returns back to the page where they
  # were which works great for the shopping experience, support logins,
  # admin, etc. But otherwise it would be great to land on the user profile
  # page.
  describe "Sees orders, keys, account info links" do
    scenario "successfully" do
      expect(page).to have_content("Order History")
      expect(page).to have_link(href: sales_order_path(@sales_order, locale: I18n.locale))
      expect(page).to have_link("Account")
      #expect(page).to have_content("Registered Products")
    end
  end

  describe "Views sales order history with product keys" do
    scenario "successfully" do
      click_on @sales_order.number

      expect(page).to have_content(@product_key.formatted_key)
      expect(page).to have_content("Related Downloads")
      expect(page).to have_content("Total: $123.99")
    end
  end

  describe "Manages account details" do
    scenario "successfully" do
      click_on "Account"

      # Devise takes over from here
      expect(page).to have_field("Name")
      expect(page).to have_field("Email")
      expect(page).to have_field("Current password")
    end
  end
end
