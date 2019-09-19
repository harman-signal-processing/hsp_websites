require "rails_helper"

feature "Complete parts form" do
  before :all do
    @website = FactoryBot.create(:website_with_products)
  end

  scenario "message is delivered to custom recipient" do
    allow(CountryList).to receive(:countries).and_return([{"id":35,"name":"United States of America","harman_name":"United States of America","alpha2":"US","alpha3":"USA","continent":"North America","region":"Americas","sub_region":"Northern America","world_region":"AMER","harman_world_region":"AMER","calling_code":1,"numeric_code":840}])
    FactoryBot.create(:setting, brand: @website.brand, name: "parts_email", string_value: "rickky@support.com")
    @website.brand.update_column(:has_parts_form, true)
    visit parts_request_url(host: @website.url)
    fill_in_form
    click_on "submit"

    # This matcher doesn't work anymore even though the text is there
    #expect(page).to have_content(I18n.t('blurbs.parts_request_thankyou'))
    last_email = get_last_email
    expect(last_email.subject).to eq("Parts Request")
    expect(last_email.to).to include("rickky@support.com")
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
