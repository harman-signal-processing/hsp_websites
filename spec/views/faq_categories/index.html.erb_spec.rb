require 'rails_helper'

RSpec.describe "faq_categories/index.html.erb", :type => :view do

  before do
    @faq_category = FactoryGirl.build_stubbed(:faq_category)
    assign(:faq_categories, [@faq_category])
    render
  end

  it "links to the categories" do
    expect(rendered).to have_link(@faq_category.name, href: faq_category_path(@faq_category))
  end

end
