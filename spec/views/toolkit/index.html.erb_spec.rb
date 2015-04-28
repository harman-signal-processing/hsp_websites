require "rails_helper.rb"

RSpec.describe "toolkit/index.html.erb", as: :view do

  before do
    @brand = FactoryGirl.create(:brand, toolkit: true)
    allow(view).to receive(:toolkit_brands).and_return([@brand])
    render
  end

  it "should use the toolkit layout" do
    expect(rendered).to have_content("Marketing Toolkit")
  end

  it "should link to brand pages" do
    expect(rendered).to have_link(@brand.name, toolkit_brand_path(@brand))
  end

end
