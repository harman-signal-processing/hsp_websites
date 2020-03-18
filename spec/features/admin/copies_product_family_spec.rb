require "rails_helper"

feature "Admin copies a product family" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryBot.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
  end

  before :each do
    admin_login_with(@user.email, "password", @website)
    click_on "Product Families"
  end

  # after :each do
  #   DatabaseCleaner.clean
  # end

  it "should make a new product family" do
    product_family_count = @brand.product_families.length
    target_family = @brand.product_families.first
    click_on target_family.name
    click_on "Copy Family"

    @brand.reload
    new_family = @brand.product_families.last
    expect(@brand.product_families.length).to eq(product_family_count + 1)
    expect(new_family.products.length).to eq(target_family.products.length)
    expect(new_family.hide_from_navigation?).to be(true)
  end

  describe "moving to another brand" do
    it "should have its brand updated" do
      another_brand = FactoryBot.create :brand
      target_family = @brand.product_families.first
      click_on target_family.name
      click_on "Edit"

      select(another_brand.name, from: "Move this family to another brand")
      click_on "Update"

      target_family.reload
      expect(target_family.brand).to eq(another_brand)
    end
  end

end

