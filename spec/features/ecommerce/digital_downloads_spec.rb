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
  end

  describe "adding an item to the cart" do
    scenario "successfully" do
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"
      expect(page.current_path).to eq(shopping_cart_path(locale: "en-US"))

      cart_summary = find(:css, ".cart_summary")
      expect(cart_summary).to have_link(@product.name)

      expect(page).to have_text("Subtotal: $100.00")
      expect(page).to have_link("Checkout")
    end
  end

  describe "removing an item from the cart"
  describe "changing quantity of an item in the cart"

  describe "checkout" do
    before :each do
      visit product_path(@product, locale: "en-US")
      click_on "Add To Cart"
      click_on "Checkout"
    end

    scenario "successfully"
      #should take payment
      #should honor promotional price (if any)
      #should create a sales_order
      #should assign the product_key to the user, email and sales order
      #should notify user via email
      #should create a user account
      #should direct user to order summary page with serial number
    #end

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

end
