require "rails_helper"

RSpec.describe "tools/_inverse_square_law.html.erb" do
  before do
    render
  end

  it "should have the form" do
    expect(rendered).to have_css("form#inverse_square_law")
  end

  it "should have the fields" do
    expect(rendered).to have_css("input[name=distance1]")
    expect(rendered).to have_css("input[name=distance2]")
    expect(rendered).to have_css("input[name=sound1]")
    expect(rendered).to have_css("input[name=sound2]")
  end
end
