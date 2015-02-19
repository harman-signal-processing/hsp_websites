require 'rails_helper'

# Feature: Complete catalog request form
#   As a site visitor
#   I want to complete the catalog request form
#   So I can get a catalog and maybe buy stuff
feature "Complete catalog request form" do
  before do
    @website = FactoryGirl.create(:website)

    visit catalog_request_url(host: @website.url)
  end

  scenario "successfully" do
    fill_in :contact_message_name, with: "Joe Schmoe"
    fill_in :contact_message_email, with: "joe@schmoe.com"
    fill_in :contact_message_shipping_address, with: "123 Anywhere"
    fill_in :contact_message_shipping_city, with: "Nowheresville"
    fill_in :contact_message_shipping_state, with: "IN"
    fill_in :contact_message_shipping_zip, with: "55555"
    select "United States", from: :contact_message_shipping_country
    click_on "submit"

    expect(page).to have_content("Thank you")
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.to).to include("service@sullivangroup.com")
    expect(last_email.subject).to eq("HARMAN Professional Catalog request")
  end

end
