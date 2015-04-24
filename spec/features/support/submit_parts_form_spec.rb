require "rails_helper"

feature "Complete parts form" do
  before do
    @website = FactoryGirl.create(:website_with_products)
  end

  scenario "message is delivered to custom recipient" do
    FactoryGirl.create(:setting, brand: @website.brand, name: "parts_email", string_value: "rickky@support.com")
    @website.brand.update_column(:has_parts_form, true)
    visit parts_request_url(host: @website.url)
    fill_in_form
    click_on "submit"

    expect(page).to have_content(I18n.t('blurbs.parts_request_thankyou'))
    last_email = get_last_email
    expect(last_email.subject).to eq("Parts Request")
    expect(last_email.to).to include("rickky@support.com")
  end

  scenario "brand doesn't support online parts form" do
    skip "Temporarily allowing parts form for all brands to debug Crown problem (4/2015)"
    visit parts_request_url(host: @website.url)

    expect(current_path).to eq(support_path(locale: I18n.default_locale))
  end

  def fill_in_form
    fill_in "Your Name", with: "Bobby"
    fill_in "Email", with: "bobby@bobberson.com"
    fill_in "Phone", with: "111-111-1111"
    select @website.products.first.name, from: "Product"
    fill_in "Additional Info", with: "I needz the parts."
  end

  def get_last_email
    ActionMailer::Base.deliveries.last
  end

end
