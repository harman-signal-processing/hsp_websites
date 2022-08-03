require 'rails_helper'

RSpec.describe "tools/calculators", :type => :view do
  before do
    render
  end

  it "has on-page nav" do
    expect(rendered).to have_link("db Power Ratio")
    expect(rendered).to have_link("db Voltage Ratio")
    expect(rendered).to have_link("Amplifier Power Required")
    expect(rendered).to have_link("Inverse Square Law")
    expect(rendered).to have_link("Ohm's/Watt's Law")
    expect(rendered).to have_link("Constant Voltage")
  end

end
