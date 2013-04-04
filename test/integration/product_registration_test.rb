require "minitest_helper"

describe "Product Registration Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}"
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "Registration form" do
  	before do
  	  visit warranty_registration_url(locale: I18n.default_locale, host: @website.url)
  	end

    it "should show the form" do
      must_have_xpath("//form[@id='new_warranty_registration']")
    end

    it "should fill in the form" do 
      fill_in_registration_form
    end

    it "should create a new registration record" do 
      start_count = WarrantyRegistration.count 
      fill_in_registration_form
      click_on 'submit'
      WarrantyRegistration.count.must_equal(start_count + 1)
    end

    it "should assign the new registration to this site's brand" do 
      fill_in_registration_form
      click_on 'submit'
      reg = WarrantyRegistration.last
      reg.brand_id.must_equal(@website.brand_id)
    end

    it "should send a confirmation email to customer" do 
      fill_in_registration_form
      click_on 'submit'
      reg = WarrantyRegistration.last 
      last_email.to.must_include(reg.email)
      last_email.subject.must_have_content("product registration")
      last_email.body.must_have_content(reg.product.name)
    end

  end

  def fill_in_registration_form
    fill_in 'warranty_registration_first_name',     with: "John"
    fill_in 'warranty_registration_last_name',      with: "Johnson"
    fill_in 'warranty_registration_email',          with: "johnny@johnson.com"
    fill_in 'warranty_registration_address1',       with: "123 Anywhere"
    fill_in 'warranty_registration_city',           with: "Anytown"
    fill_in 'warranty_registration_state',          with: "CA"
    fill_in 'warranty_registration_zip',            with: "90210"
    fill_in 'warranty_registration_phone',          with: "555-555-5555"
    fill_in 'warranty_registration_serial_number',  with: "123" + rand().to_s
    fill_in 'warranty_registration_purchased_on',   with: 2.weeks.ago.to_s
    fill_in 'warranty_registration_purchased_from', with: "Musician's Friend"
    fill_in 'warranty_registration_purchase_price', with: "$100.00"
    select 'United States',                   from: 'warranty_registration_country'
    select @website.brand.products.last.name, from: 'warranty_registration_product_id'
  end

end