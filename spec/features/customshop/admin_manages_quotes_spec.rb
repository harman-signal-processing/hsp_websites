require "rails_helper"

feature "An admin manages requested quotes" do
  include ActiveJob::TestHelper

  before do
    @website = FactoryBot.create(:website)
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"

    @product1 = create(:product, brand: @brand)
    @product2 = create(:product, brand: @brand)
    cart = create(:custom_shop_cart)
    create(:custom_shop_line_item, custom_shop_cart: cart, product: @product1, quantity: 2)
    create(:custom_shop_line_item, custom_shop_cart: cart, product: @product2, quantity: 10)
    @custom_shop_quote = create(:custom_shop_quote, custom_shop_cart: cart)

    @user = FactoryBot.create(:user, custom_shop_admin: true, password: "password", confirmed_at: 1.minute.ago)
    signin(@user.email, "password")
  end

  describe "Adding pricing" do
    it "is successful" do
      # starting on profile page
      click_on "Custom Shop Quotes"
      click_on @custom_shop_quote.number
      click_on "Add/Edit Pricing"
      fill_in "#{@product1.name} Price", with: "1200"
      fill_in "#{@product2.name} Price", with: "9000"
      select "quoted", from: "Status"
      click_on "Update"

      expect(page).to have_text("Status: Quoted")
      expect(page).to have_text("$1,200") # line item 1
      expect(page).to have_text("$2,400") # x 2
      expect(page).to have_text("$9,000") # line item 2
      expect(page).to have_text("$90,000") # x 10
      expect(page).to have_text("$92,400") # total
    end
  end

  describe "Notify customer" do
    it "is successful" do
      skip "Add specs for notifying customer when updating quote"
    end
  end
end

# NOTE: Need a search interface for pending/existing quotes
