require "rails_helper"

feature "Admin sets up a product for digital download ecommerce" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    @brand = @website.brand
    FactoryBot.create(:product_types)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryBot.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
  end

  before :each do
    admin_login_with(@user.email, "password", @website)
  end

  it "should enable a product for digital download ecommerce" do
    click_on "Products"
    product = @brand.products.first
    click_on product.name

    expect(product.product_type.name).to eq("Standard")
    click_on "Edit Product Descriptions"

    select("Ecommerce-Digital Download", from: "Product type")
    click_on "Update Product"

    product.reload
    expect(product.product_type.name).to eq("Ecommerce-Digital Download")
  end

  it "should load serial numbers from CMS (top menu)" do
    product = @brand.products.first
    product.update(product_type: ProductType.digital_ecom)

    click_on "Digital Inventory"
    click_on product.name
    fill_in :new_keys, with: "1234\r\n5678\r\n91011"
    click_on "Add inventory"

    expect(product.available_product_keys.length).to eq(3)
    expect(page).to have_text("Available inventory: 3")
  end

  it "should load serial numbers from the admin product page" do
    product = @brand.products.first
    product.update(product_type: ProductType.digital_ecom)

    visit admin_product_path(product, locale: "en-US")

    click_on "Manage digital inventory"

    expect(page.current_path).to eq(admin_product_product_keys_path(product, locale: "en-US"))
  end

  it "should load serial numbers from product page" do
    product = @brand.products.first
    product.update(product_type: ProductType.digital_ecom)

    visit product_path(product, locale: "en-US")

    expect(page).to have_link("Available digital inventory: 0") # click is handled by js

    fill_in :new_keys, with: "1234\r\n5678\r\n91011"
    click_on "Add inventory"

    expect(product.available_product_keys.length).to eq(3)
    expect(page.current_path).to eq(product_path(product, locale: "en-US"))
    expect(page).to have_text("Available digital inventory: 3")
  end

  describe "Low stock notifications" do
    scenario "admin can subscribe and set low-stock threshhold"
    scenario "subscribed users get notified when stock hits threshhold"
  end
end

