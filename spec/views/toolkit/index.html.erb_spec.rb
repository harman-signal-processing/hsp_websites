require "rails_helper.rb"

RSpec.describe "toolkit/index.html.erb", as: :view do

  before :all do
    @brand = FactoryBot.create(:brand, toolkit: true)
  end

  before :each do
    allow(view).to receive(:toolkit_brands).and_return([@brand])
    render
  end

  it "should use the toolkit layout" do
    expect(rendered).to have_content("Marketing Toolkit")
  end

  it "should link to brand pages" do
    expect(rendered).to have_link(@brand.name, href: toolkit_brand_path(@brand))
  end

end
