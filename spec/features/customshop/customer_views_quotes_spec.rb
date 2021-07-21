require "rails_helper"

feature "A customer manages requested quotes" do

  before do
    @website = FactoryBot.create(:website)
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"

    @password = "Password123"
    @user = create(:user, password: @password, customer: true, password_confirmation: @password, email: 'joe@schmoe.com')

    @product1 = create(:product, brand: @brand)
    @product2 = create(:product, brand: @brand)
    cart = create(:custom_shop_cart)
    create(:custom_shop_line_item, custom_shop_cart: cart, product: @product1, quantity: 2)
    create(:custom_shop_line_item, custom_shop_cart: cart, product: @product2, quantity: 10)
    @custom_shop_quote = create(:custom_shop_quote, user: @user, custom_shop_cart: cart)
  end

  describe "viewing a newly requested quote" do
    before do
      signin(@user.email, @password)
    end

    it "is successful" do
      expect(page.current_path).to match("profile")
      expect(page).to have_text("Custom Shop History")

      click_on @custom_shop_quote.number
      expect(page).to have_text("Status: New")
      expect(page).to have_text(@custom_shop_quote.number)
      expect(page).to have_text(@custom_shop_quote.custom_shop_line_items.first.product.name)
      expect(page).not_to have_text("$0.00")
      expect(page).to have_text(@custom_shop_quote.opportunity_number)
      expect(page).to have_text(@custom_shop_quote.account_number)
      expect(page).to have_text(@custom_shop_quote.description)
      expect(page).to have_text(I18n.l(@custom_shop_quote.request_delivery_on, format: :long))
    end
  end

  describe "viewing a quote with pricing" do
    before do
      @custom_shop_quote.custom_shop_line_items.first.update(quantity: 2, price: "2100")
      @custom_shop_quote.custom_shop_line_items.last.update(quantity: 10, price: "900")
      @custom_shop_quote.update(status: "quoted")
      signin(@user.email, @password)
      visit custom_shop_custom_shop_quote_path(@custom_shop_quote, locale: I18n.default_locale)
    end

    it "is successful" do
      expect(page).to have_text("Status: Quoted")
      expect(page).to have_text(@custom_shop_quote.number)
      expect(page).to have_text(@custom_shop_quote.custom_shop_line_items.first.product.name)
      expect(page).to have_text("$2,100")
      expect(page).to have_text("$4,200")
      expect(page).to have_text("Total: $13,200") # total with the other fake line item
    end
  end
end


