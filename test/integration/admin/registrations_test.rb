require "test_helper"

describe "Admin Registrations Integration Test" do

  before :each do
    # DatabaseCleaner.start
    # Brand.destroy_all
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, url: "digitech.lvh.me")
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
    
    @reg = FactoryGirl.create(:warranty_registration, brand: @brand, product: @website.products.first)
    @user = FactoryGirl.create(:user, customer_service: true, password: "password")
    admin_login_with(@user, "password", @website)
    click_on "Product Registrations"
  end

  # after :each do
  #   DatabaseCleaner.clean
  # end

  it "should search by name" do 
    fill_in "q_first_name_cont", with: @reg.first_name
    click_on "Search"
    page.must_have_link "#{@reg.first_name} #{@reg.last_name}"
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