require 'rails_helper'

RSpec.describe "support/catalog_request.html.erb", :type => :view do

  before :all do
    @website = FactoryGirl.create(:website)
    @contact_message = FactoryGirl.build(:contact_message, message_type: "catalog_request")
  end

  before do
    allow(view).to receive(:website).and_return(@website)
    assign(:contact_message, @contact_message)

    render
  end

  it "has all the fields" do
    expect(rendered).to have_css("input#contact_message_name")
    expect(rendered).to have_css("input#contact_message_shipping_address")
    expect(rendered).to have_css("input#contact_message_shipping_city")
    expect(rendered).to have_css("input#contact_message_shipping_state")
    expect(rendered).to have_css("input#contact_message_shipping_zip")
    expect(rendered).to have_css("select#contact_message_shipping_country")
    expect(rendered).to have_css("input#contact_message_email")
  end

end
