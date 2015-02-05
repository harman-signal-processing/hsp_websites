require 'rails_helper'

RSpec.describe "tools/_ohms_watts_law.html.erb", :type => :view do
  before do
    render
  end

  it "should have the form" do
    expect(rendered).to have_css("form#ohms_watts_law")
  end

  it "should have the fields" do
    expect(rendered).to have_css("input[name=x]")
    expect(rendered).to have_css("input[name=i]")
    expect(rendered).to have_css("input[name=r]")
    expect(rendered).to have_css("input[name=p]")
  end

end
