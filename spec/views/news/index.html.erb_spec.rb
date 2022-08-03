require 'rails_helper'

RSpec.describe "news/index", :type => :view do
  before :all do
    @website = FactoryBot.create(:website)
    @news = FactoryBot.create(:news)
    FactoryBot.create(:brand_news, brand: @website.brand, news: @news)
  end

  before :each do
    allow(view).to receive(:website).and_return(@website)
    assign(:news, News.all.paginate(page: 1, per_page: 20))
    render
  end

  it "should link to news story" do
    expect(rendered).to have_link(@news.title, href: news_path(@news))
  end

end
