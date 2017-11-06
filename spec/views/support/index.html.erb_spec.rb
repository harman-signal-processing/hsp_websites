require "rails_helper"

RSpec.describe "support/index.html.erb", as: :view do

  before :all do
    @website = FactoryBot.create(:website)
    @other_brand = FactoryBot.create(:brand)
    @other_product = FactoryBot.create(:discontinued_product, brand: @other_brand)
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)
    assign(:contact_message, ContactMessage.new)

    render
  end

  it "should not have other brand products" do
    expect(rendered).not_to have_xpath("//option[@value='#{@other_product.to_param}']")
  end

end
