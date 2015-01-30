require 'rails_helper'

# Feature: Complete contact form with standard subjects
#   As a site visitor
#   I want to complete the contact form
#   So I can get an answer to my question
feature "Complete contact form with standard subjects" do
  before do
    @website = FactoryGirl.create(:website_with_products)

    visit support_url(host: @website.url)
    fill_in_form
  end

  scenario "default subjects shown, message is delivered to default recipient" do
    select "Technical Support", from: "Subject"
    click_on "submit"

    expect(page).to have_content(I18n.t('blurbs.contact_form_thankyou'))
    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.to).to include(@website.brand.support_email)
  end

  def fill_in_form
    fill_in "Your Name", with: "Bobby"
    fill_in "Email", with: "bobby@bobberson.com"
    fill_in "Message", with: "Please help me make the musics."
    select @website.products.first.name, from: "Product"
  end

end
