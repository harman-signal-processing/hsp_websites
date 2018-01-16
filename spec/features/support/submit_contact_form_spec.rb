require 'rails_helper'

# Feature: Complete contact form
#   As a site visitor
#   I want to complete the contact form
#   So I can get an answer to my question
feature "Submit contact form" do
  before :all do
    @website = FactoryBot.create(:website_with_products)
  end

  before :each do
    visit support_url(host: @website.url)
  end

  scenario "successfully" do
    select ContactMessage.subjects.last[0], from: "contact_message_subject"
    fill_in "contact_message_name", with: "Joe"
    fill_in "contact_message_email", with: "joe@joe.com"
    select @website.products.first.name, from: "contact_message_product"
    fill_in "contact_message_product_serial_number", with: "12345"
#    fill_in "contact_message_operating_system", with: "Lion"
    fill_in "contact_message_shipping_address", with: "123 Anywhere"
    select "United States", from: "contact_message_shipping_country"
    fill_in "contact_message_phone", with: "555-5555"
    fill_in "contact_message_message", with: "Hi Dean. How are you?"
    click_on "submit"

    expect(current_path).to eq(support_path(locale: I18n.default_locale))
  end

  scenario "will NOT require the country" do
    message_count = ContactMessage.count

    select ContactMessage.subjects.last[0], from: "contact_message_subject"
    select @website.products.first.name, from: "contact_message_product"
    fill_in "contact_message_name", with: "Joe"
    fill_in "contact_message_email", with: "joe@joe.com"
    fill_in "contact_message_message", with: "Hi Dean. How are you?"
    click_on("submit")

    expect(page).not_to have_content("can't be blank")
    expect(ContactMessage.count).to eq(message_count + 1)
  end

  it "requires a product" do
    message_count = ContactMessage.count

    select ContactMessage.subjects.last[0], from: "contact_message_subject"
    fill_in "contact_message_name", with: "Joe"
    fill_in "contact_message_email", with: "joe@joe.com"
    fill_in "contact_message_message", with: "Hi Dean. How are you?"
    click_on("submit")

    expect(page).to have_content("can't be blank")
    expect(ContactMessage.count).to eq(message_count)
  end

end
