require 'rails_helper'

# Feature: Complete contact form with different recipients
#   As a site visitor
#   I want to complete the contact form
#   And have it go directly to the corresponding person
#   So I can get an answer to my question
feature "Complete contact form with custom recipients" do
  before :all do
    @website = FactoryBot.create(:website_with_products)
    @subjects = FactoryBot.create_list(:support_subject, 2, brand_id: @website.brand_id)
    @subjects.first.update_column(:recipient, "mrcool@harman.com")
  end

  scenario "message is delivered to recipient corresponding to the selected subject" do
    visit support_url(host: @website.url)
    fill_in_form
    select @subjects.first.name, from: "Subject"
    click_on "submit"

    last_email = get_last_email
    expect(last_email.subject).to eq(@subjects.first.name)
    expect(last_email.to).to include("mrcool@harman.com")
  end

  scenario "message is delivered to multiple custom recipients" do
    @recipient1 = "mrcool@harman.com"
    @recipient2 = "joeschmoe@harman.com"
    @subjects.last.update_column(:recipient, "#{@recipient1}, #{@recipient2}")

    visit support_url(host: @website.url)
    fill_in_form
    select @subjects.last.name, from: "Subject"
    click_on "submit"

    last_email = get_last_email
    expect(last_email.subject).to eq(@subjects.last.name)
    expect(last_email.to.length).to be > 1
    expect(last_email.to).to include(@recipient1)
    expect(last_email.to).to include(@recipient2)
  end

  scenario "message is delivered to default recipient" do
    @subjects.last.update_column(:recipient, '')

    visit support_url(host: @website.url)
    fill_in_form
    select @subjects.last.name, from: "Subject"
    click_on "submit"

    last_email = get_last_email
    expect(last_email.to).to include(@website.brand.support_email)
  end

  def fill_in_form
    fill_in "Your Name", with: "Bobby"
    fill_in "Email", with: "bobby@bobberson.com"
    select @website.products.first.name, from: "Product"
    fill_in "Message", with: "Please help me make the musics."
  end

  def get_last_email
    ActionMailer::Base.deliveries.last
  end

end
