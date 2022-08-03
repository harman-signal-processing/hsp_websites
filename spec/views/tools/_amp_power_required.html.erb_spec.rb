require 'rails_helper'

RSpec.describe "tools/_amp_power_required", :type => :view do
  before do
    render
  end

  it "should have the form" do
    expect(rendered).to have_css("form#amp_power_required")
  end

  it "should have the fields" do
    expect(rendered).to have_css("input[name=d2]")
    expect(rendered).to have_css("input[name=lreq]")
    expect(rendered).to have_css("input[name=lsens]")
    expect(rendered).to have_css("input[name=hr]")
    expect(rendered).to have_css("input[name=w]")
  end

end
