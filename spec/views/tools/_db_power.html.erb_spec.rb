require 'rails_helper'

RSpec.describe "tools/_db_power.html.erb", :type => :view do
  before do
    render
  end

  it "should have the form" do
    expect(rendered).to have_css("form#db_power")
  end

  it "should have the fields" do
    expect(rendered).to have_css("input#mult[type=hidden][value='10']")
    expect(rendered).to have_css("input[name=pin]")
    expect(rendered).to have_css("input[name=pout]")
    expect(rendered).to have_css("input[name=pdB]")
  end

end
