require "rails_helper"

feature "User shops for downloadable goods requiring a product key" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    @brand = @website.brand
    FactoryBot.create(:product_types)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @product = @brand.products.first
    @product.update(
      product_type: ProductType.digital_ecom,
      msrp: 200, street_price: 100
    )
    @product_key = create(:product_key, product: @product)
  end

  describe "adding an item to the cart" do
    scenario "successfully" do
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"
      expect(page.current_path).to eq(shopping_cart_path(locale: "en-US"))

      expect(page).to have_link("1", href: shopping_cart_path(locale: "en-US"))

      cart_summary = find(:css, ".cart_summary")
      expect(cart_summary).to have_link(@product.name)

      expect(page).to have_text("Total: $100.00")
      expect(page).to have_link("Checkout")
    end
  end

  describe "removing an item from the cart" do
    scenario "successfully" do
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"

      click_on(id: "remove-#{@product.id}")

      expect(page).to have_text("Your shopping cart is empty.")
    end
  end

  describe "changing quantity of an item in the cart" do
    scenario "successfully"
  end

  describe "existing customer checkout"

  describe "new customer checkout" do
    before :each do
      @available_product_key = FactoryBot.create(:product_key, product_id: @product.id)
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"
    end

    scenario "successfully creates a sales order and assigns product key to customer" do
      skip "Work out javascript testing for adyen"
      original_product_keys_count = @product.available_product_keys.length
      new_customer = FactoryBot.build(:user)
      click_on "Checkout"

      # New user must register
      click_on "register"
      fill_in "Name", with: new_customer.name
      fill_in "Email", with: new_customer.email
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_on "Sign up"

      # User is now logged in and directed to the checkout page
      fill_in "Card number", with: "4000 0200 0000 0000"
      fill_in "Expiry Date", with: "03/30"
      fill_in "CVC/CVV", with: "737"
      fill_in "Name on card", with: "J. Smith"
      click_on "Pay"

      new_sales_order = SalesOrder.last
      expect(new_sales_order.customer.email).to eq(new_customer.email)
      expect(page).to have_content("Order Number: #{ new_sales_order.number }")

      new_user = User.last
      expect(@product.available_product_keys.length).to eq(original_product_keys_count - 1)
      expect(new_user.product_keys.length).to eq(1)
      assigned_product_key = new_user.product_keys.first
      expect(assigned_product_key.sales_order).to eq(new_sales_order)

      expect(page).to have_content("Success")
      expect(page).to have_content(assigned_product_key.key)

      #should honor promotional price (if any)
      #should assign the right quantity of each
      #should take payment
      #should notify user via email
    end

    scenario "failure"
     #should attempt a payment but fail
     #should not create a sales order
     #should not assign a product_key
     #should not notify user via email
     #should not attempt to create a user account
     #should not direct to order summary
     #should offer user to retry payment
    #end
  end

  describe "zero inventory" do
    scenario "should not allow checkout but revert to previous buy-it-now system" do
      @product.product_keys = []
      @product.save

      visit product_path(@product, locale: "en-US")
      expect(page).not_to have_link("Add To Cart")
      expect(page).to have_link("Buy It Now")

      click_on "Buy It Now"
      expect(page.current_path).to eq(where_to_find_path(locale: I18n.locale))
    end
  end

end
