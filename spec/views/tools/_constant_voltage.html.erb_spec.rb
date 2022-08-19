require 'rails_helper'

RSpec.describe "tools/_constant_voltage", :type => :view do
  before do
    render
  end

  it "should have the form" do
    expect(rendered).to have_css("form#constant_voltage")
  end

  it "should have the fields" do
    expect(rendered).to have_css("input[name=vnew]")
    expect(rendered).to have_css("input[name=vrated]")
    expect(rendered).to have_css("input[name=prated]")
    expect(rendered).to have_css("input[name=pactual]")
  end

end
