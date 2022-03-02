require "rails_helper"

feature "A customer builds price requestfor custom product" do
  include ActiveJob::TestHelper

  before do
    @brand = FactoryBot.create(:brand, name: "JBL Pro")
    @website = FactoryBot.create(:website, brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @product_family = FactoryBot.create(:product_family_with_products, brand: @website.brand, products_count: 5)
    @product1 = @product_family.current_products[0]
    @product2 = @product_family.current_products[1]

    @customizable_attribute = create(:customizable_attribute, name: "Color")
    @product_family.customizable_attributes << @customizable_attribute

    @product1.customizable_attribute_values << create(:customizable_attribute_value, customizable_attribute: @customizable_attribute, value: "white")
    @product1.customizable_attribute_values << create(:customizable_attribute_value, customizable_attribute: @customizable_attribute, value: "gray")
    @product2.customizable_attribute_values << create(:customizable_attribute_value, customizable_attribute: @customizable_attribute, value: "white")
    @product2.customizable_attribute_values << create(:customizable_attribute_value, customizable_attribute: @customizable_attribute, value: "gray")

    @password = "Password123"
    @user = create(:user, password: @password, password_confirmation: @password, email: 'joe@schmoe.com')
  end

  describe "adding multiple customizable products" do
    it "is successful" do
      visit custom_shop_path

      expect(page).to have_text(@product_family.name)
      expect(page).to have_text(@product1.name)
      click_on("Customize #{@product1.name}")

      choose "white"
      click_on("Add To Price Request")

      expect(page).to have_text("#{@product1.name} has been added to your price request")
      expect(page).to have_text("Color: white")
      click_on("Add Another Product")
      click_on("Customize #{@product2.name}")

      choose option: "gray"
      fill_in "Quantity", with: "144"
      click_on("Add To Price Request")

      expect(page).to have_text("#{@product2.name} has been added to your price request")
      expect(page).to have_text("Color: gray")
      expect(page).to have_field(id: "custom_shop_line_item_quantity", with: "144")

      perform_enqueued_jobs do
        click_on("Request Pricing")

        fill_in "Email", with: @user.email
        fill_in "Password", with: @password
        click_on("Sign in")

        fill_in "Account Number", with: "H123"
        fill_in "Opportunity number", with: "OP692"
        click_on("Request Pricing")

        expect(page).to have_text("Your price request has been submitted.")

        custom_shop_price_request = CustomShopPriceRequest.last
        last_email = ActionMailer::Base.deliveries.last
        expect(last_email.subject).to have_text("Custom Shop Price Request")
        expect(last_email.body).to have_text("joe@schmoe.com")
        expect(last_email.body).to have_text("H123")
        expect(last_email.body).to have_text("OP692")
        expect(last_email.body).to have_text(@product1.name)
        expect(last_email.body).to have_link(custom_shop_price_request.number)
      end
    end
  end

  describe "editing a line item on a price request" do
    it "is successful" do
      visit custom_shop_path

      click_on("Customize #{@product1.name}")
      choose "white"
      click_on("Add To Price Request")

      click_on("Edit #{@product1.name}")
      choose "gray"
      fill_in "Quantity", with: "92"
      click_on("Update Price Request")

      expect(page).to have_text("#{@product1.name} was updated")
      expect(page).to have_text("Color: gray")
      expect(page).to have_field(id: "custom_shop_line_item_quantity", with: "92")
    end
  end

  describe "removing a line item from a price request" do
    it "is successful" do
      visit custom_shop_path

      click_on("Customize #{@product1.name}")
      choose "white"
      click_on("Add To Price Request")

      @line_item = CustomShopLineItem.last
      click_on(id: "remove-#{@line_item.id}")

      expect(page).not_to have_text("Color: white")
      expect(page).to have_text("Your price request appears to be empty")
    end
  end

  describe "setting a line item quantity to zero" do
    it "removes it from the price request" do
      visit custom_shop_path

      click_on("Customize #{@product1.name}")
      choose "white"
      click_on("Add To Price Request")

      click_on("Edit #{@product1.name}")
      fill_in "Quantity", with: "0"
      click_on("Update Price Request")

      expect(page).not_to have_text("Color: white")
      expect(page).to have_text("Your price request appears to be empty")
    end
  end

  describe "new user builds a price request" do
    it "is successful" do
      new_user = build(:user)

      visit custom_shop_path

      expect(page).to have_text(@product_family.name)
      expect(page).to have_text(@product1.name)
      click_on("Customize #{@product1.name}")

      choose "white"
      click_on("Add To Price Request")

      expect(page).to have_text("#{@product1.name} has been added to your price request")
      expect(page).to have_text("Color: white")

      click_on("Request Pricing")

      expect {
        click_on "register"
        fill_in "Name", with: new_user.name
        fill_in "Email", with: new_user.email
        fill_in "Password", with: "password123"
        fill_in "Password confirmation", with: "password123"
        click_on "Sign up"
      }.to change(User, :count).by(+1)

      perform_enqueued_jobs do
        fill_in "Account Number", with: "H123"
        click_on("Request Pricing")

        expect(page).to have_text("Your price request has been submitted.")

        last_email = ActionMailer::Base.deliveries.last
        expect(last_email.subject).to have_text("Custom Shop Price Request")
        expect(last_email.body).to have_text(new_user.email)
        expect(last_email.body).to have_text("H123")
      end
    end
  end

end

# NOTE: Add country to user table
