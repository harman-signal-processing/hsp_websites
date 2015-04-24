require "rails_helper"

feature "Complete rma form" do
  before do
    @website = FactoryGirl.create(:website_with_products)
  end

  scenario "message is delivered to custom recipient" do
    FactoryGirl.create(:setting, brand: @website.brand, name: "rma_email", string_value: "ramesh@support.com")
    @website.brand.update_column(:has_rma_form, true)
    visit rma_request_url(host: @website.url)
    fill_in_form
    click_on "submit"

    expect(page).to have_content(I18n.t('blurbs.rma_request_thankyou'))
    last_email = get_last_email
    expect(last_email.subject).to eq("RMA Request")
    expect(last_email.to).to include("ramesh@support.com")
  end

  scenario "brand doesn't support online rma form" do
    skip "Temporarily allowing RMA form for all brands to debug Crown problem (4/2015)"
    visit rma_request_url(host: @website.url)

    expect(current_path).to eq(support_path(locale: I18n.default_locale))
  end

  def fill_in_form
    fill_in "Your Name", with: "Bobby"
    fill_in "Email", with: "bobby@bobberson.com"
    fill_in "Phone", with: "111-111-1111"
    fill_in :contact_message_shipping_address, with: "123 My Street"
    fill_in :contact_message_shipping_city, with: "Nowhere"
    fill_in :contact_message_shipping_state, with: "IN"
    fill_in :contact_message_shipping_zip, with: "60471"
    select @website.products.first.name, from: "Product"
    fill_in "Serial Number", with: "12345"
    fill_in "Purchase date", with: 1.year.ago
    fill_in "Detailed problem description", with: "I broked it."
  end

  def get_last_email
    ActionMailer::Base.deliveries.last
  end

end
