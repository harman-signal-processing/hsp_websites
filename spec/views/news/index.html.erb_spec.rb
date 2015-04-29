require 'rails_helper'

RSpec.describe "news/index.html.erb", :type => :view do
  before do
    @website = FactoryGirl.create(:website_with_products)
    @news = FactoryGirl.create(:news, brand: @website.brand)
    allow(view).to receive(:website).and_return(@website)
    assign(:news, [@news])
    render
  end

  it "should link to news story" do
    expect(rendered).to have_link(@news.title, href: news_path(@news))
  end

end
