require 'rails_helper'

RSpec.describe "news/index.html.erb", :type => :view do
  before :all do
    @website = FactoryBot.create(:website)
    @news = FactoryBot.build_stubbed(:news, brand: @website.brand)
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)
    assign(:news, [@news])
    render
  end

  it "should link to news story" do
    expect(rendered).to have_link(@news.title, href: news_path(@news))
  end

end
