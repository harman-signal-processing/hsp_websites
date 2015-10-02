require "rails_helper"

feature "Lexicon support page" do

  before do
    @brand = FactoryGirl.create(:lexicon_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"

    visit support_path
  end

  scenario "Country field is required" do
    message_count = ContactMessage.count
    expect(page).to have_content "* Country"

    select @brand.products.first.name, from: "contact_message_product"
    select ContactMessage.subjects.last[0], from: "contact_message_subject"
    fill_in "contact_message_name", with: "Joe"
    fill_in "contact_message_email", with: "joe@joe.com"
    fill_in "contact_message_message", with: "Hi Dean. How are you?"
    click_on("submit")

    expect(page).to have_content("can't be blank")
    expect(ContactMessage.count).not_to eq(message_count + 1)
  end
end
