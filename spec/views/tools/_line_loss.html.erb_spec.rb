require "rails_helper"

RSpec.describe "tools/_line_loss" do
  before do
    render
  end

  it "should have the form" do
    expect(rendered).to have_css("form#line_loss")
  end

  it "should have the fields" do
    expect(rendered).to have_css("input[name=prated]")
    expect(rendered).to have_css("input[name=ploss]")
    expect(rendered).to have_css("input[name=vline]")
    expect(rendered).to have_css("select[name=r1]")
    expect(rendered).to have_css("input[name=r2]")
  end
end
