require 'rails_helper'

RSpec.describe "support/catalog_request.html.erb", :type => :view do

  before do
    @contact_message = FactoryGirl.build(:contact_message, message_type: "catalog_request")
    assign(:support_subject, @support_subject)
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
