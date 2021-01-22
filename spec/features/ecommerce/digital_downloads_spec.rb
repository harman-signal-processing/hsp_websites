require "rails_helper"

feature "User shops for downloadable goods requiring a product key" do

  before :all do
    @brand = FactoryBot.create(:lexicon_brand)
    @website = FactoryBot.create(:website_with_products, brand: @brand, folder: "lexicon")
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
    before(:each) do
      create(:product_key, product: @product)
    end

    scenario "successfully" do
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"

      fill_in "line_item_quantity", with: 2
      click_on "update"

      expect(page).to have_text("Total: $200.00")
    end

    scenario "fails with negative quantity" do
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"

      fill_in "line_item_quantity", with: "-100"
      click_on "update"

      expect(page).to have_content("There was a problem")
      expect(page).to have_text("Total: $100.00")
    end

    scenario "reverts to maximum available quantity" do
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"

      # only 2 available
      fill_in "line_item_quantity", with: 5
      click_on "update"

      expect(page).to have_text("Total: $200.00")
    end
  end

  describe "zero inventory", js: false do
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

  describe "new customer checkout", js: true, vcr: true do

    scenario "successfully creates a sales order and assigns product key to customer" do
      skip "Works, but the test is slow so comment-out this line when you want to run it."

      @available_product_key = FactoryBot.create(:product_key, product_id: @product.id)
      original_product_keys_count = @product.available_product_keys.length
      new_customer = FactoryBot.build(:user)
      new_address = FactoryBot.build(:address)

      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"
      click_on "Checkout"

      # New user must register
      expect {
        click_on "register"
        fill_in "Name", with: new_customer.name
        fill_in "Email", with: new_customer.email
        fill_in "Password", with: "password123"
        fill_in "Password confirmation", with: "password123"
        click_on "Sign up"
      }.to change(User, :count).by(+1)

      new_user = User.last
      expect(new_user.email).to eq(new_customer.email)

      # User is now logged in and directed to the checkout page
      expect {
        fill_in "Billing Address", with: new_address.street_1
        fill_in "City", with: new_address.locality
        fill_in "State", with: new_address.region
        fill_in "Zipcode", with: new_address.postal_code
        select new_address.country, from: "Country"
        click_on "Continue" # payment is on next screen so we can add tax if needed
      }.to change(Address, :count).by(+1)

      expect(new_user.addresses.length).to eq(1)

      # User has supplied address and continues to payment page
      sleep(1) # Wait for adyen drop-in to load
      expect {
        cardframe = find(".adyen-checkout__card__cardNumber__input").find(".js-iframe")
        within_frame cardframe do
          fill_in("encryptedCardNumber", with: "5136 3333 3333 3335")
        end

        expframe = find(".adyen-checkout__card__exp-date__input").find(".js-iframe")
        within_frame expframe do
          fill_in("encryptedExpiryDate", with: "03/30")
        end

        cvvframe = find(".adyen-checkout__card__cvc__input").find(".js-iframe")
        within_frame cvvframe do
          fill_in("encryptedSecurityCode", with: "737")
        end

        find("input.adyen-checkout__card__holderName__input").set(new_customer.name)
        click_on class: "adyen-checkout__button--pay"

        sleep(1) # Wait for adyen to finish
      }.to change(SalesOrder, :count).by(+1)

      new_sales_order = SalesOrder.last
      expect(new_sales_order.user.email).to eq(new_customer.email)
      expect(page).to have_content("Order ##{ new_sales_order.number }")
      expect(new_sales_order.address.postal_code.length).to eq(10) #new_address.postal_code)
      expect(@product.available_product_keys.length).to eq(original_product_keys_count - 1)
      expect(new_user.product_keys.length).to eq(1)
      assigned_product_key = new_user.product_keys.first
      expect(assigned_product_key.sales_order).to eq(new_sales_order)

      expect(page).to have_content(assigned_product_key.formatted_key)

    end

  end

end
