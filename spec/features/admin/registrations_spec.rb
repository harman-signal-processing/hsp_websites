require "rails_helper"

feature "Admin Registrations" do

  before :all do
    @website = FactoryBot.create(:website_with_products)
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryBot.create(:user, customer_service: true, password: "password", confirmed_at: 1.minute.ago)
    @reg = FactoryBot.create(:warranty_registration, brand: @brand, product: @website.products.first)
  end

  before :each do
    admin_login_with(@user.email, "password", @website)
    click_on "Product Registrations"
  end

  # after :each do
  #   DatabaseCleaner.clean
  # end

  it "should search by name" do
    fill_in "q_first_name_or_last_name_or_email_cont", with: @reg.first_name
    click_on "Search"

    expect(page).to have_link "#{@reg.first_name} #{@reg.last_name}"
  end

  # it "should search by email" do
  #   fill_in "q_email_cont", with: @reg.email
  #   click_on "Search"
  #   page.must_have_content @reg.email
  # end

  # it "should have an export button" do
  #   page.must_have_link "Excel"
  # end

end
