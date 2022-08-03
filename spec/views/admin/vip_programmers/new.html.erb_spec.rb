require 'rails_helper'

RSpec.describe "admin/vip_programmers/new", type: :view do
  before :all do
    @vip_programmer = FactoryBot.create(:vip_programmer)
  end
  
  before :each do
  	render
  end
  
  it "Vip::Programmer New form should expected fields" do
    expect(rendered).to have_field("Name", with:"Programmer 1")
    expect(rendered).to have_field("Description", with:"Programmer 1 description")
    expect(rendered).to have_field("Examples", with:"Programmer 1 examples")
    expect(rendered).to have_field("Security Clearance", with:"Programmer 1 security_clearance")
    expect(rendered).to have_select("Pick Logo")
  end
end
