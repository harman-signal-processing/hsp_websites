require "rails_helper"

feature "Product Registration" do
  include ActiveJob::TestHelper

  before :all do
    @website = FactoryBot.create(:website_with_products)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  describe "Registration form" do
  	before do
  	  visit warranty_registration_path(locale: I18n.default_locale)

      fill_in_registration_form
  	end

    it "should create a new registration record" do
      start_count = WarrantyRegistration.count

      click_on 'submit'

      expect(WarrantyRegistration.count).to eq(start_count + 1)
    end

    it "should assign the new registration to this site's brand" do
      click_on 'submit'

      reg = WarrantyRegistration.last
      expect(reg.brand_id).to eq(@website.brand_id)
    end

    it "should send a confirmation email to customer" do
      skip "2022-12 Disabled email conf due to spam complaint"
      perform_enqueued_jobs do
        click_on 'submit'

        reg = WarrantyRegistration.last
        last_email = ActionMailer::Base.deliveries.last
        expect(last_email.to).to include(reg.email)
        expect(last_email.subject).to include "product registration"
        expect(last_email.body).to include reg.product.name
      end
    end

  end

  def fill_in_registration_form
    fill_in 'warranty_registration_first_name',     with: "John"
    fill_in 'warranty_registration_last_name',      with: "Johnson"
    fill_in 'warranty_registration_email',          with: "johnny@johnson.com"
    fill_in 'warranty_registration_serial_number',  with: "123" + rand().to_s
    # Not needed, js calendar fills in default date
    # fill_in 'warranty_registration_purchased_on',   with: 2.weeks.ago.to_s
    # Purchase details fields removed 4/2024
    # fill_in 'warranty_registration_purchased_from', with: "Musician's Friend"
    # fill_in 'warranty_registration_purchase_price', with: "$100.00"
    select 'United States',                   from: 'warranty_registration_country'
    select @website.brand.products.last.name, from: 'warranty_registration_product_id'
  end

end
