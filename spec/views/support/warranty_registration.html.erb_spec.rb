require "rails_helper"

RSpec.describe "support/warranty_registration.html.erb", as: :view do

  before :all do
    @website = FactoryGirl.create(:website)
    @warranty_registration = FactoryGirl.build(:warranty_registration)
    assign(:warranty_registration, @warranty_registration)
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)

    render
  end

  it "should show the form" do
    expect(rendered).to have_xpath("//form[@id='new_warranty_registration']")
  end

end
