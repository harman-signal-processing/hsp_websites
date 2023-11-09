require 'rails_helper'

RSpec.describe "products/show", :type => :view do
  before :all do
    @website = FactoryBot.create(:website)
    @product = FactoryBot.create(:product, brand: @website.brand)
    @news = FactoryBot.create(:news)
    @news.brands << @website.brand
    @future_news = FactoryBot.create(:news, post_on: 1.month.from_now, title: "Future News")
    @future_news.brands << @website.brand
    @product.news += [@news, @future_news]
    assign(:product, @product)
  end

  before :each do
    allow(view).to receive(:current_user).and_return(User.new)
    allow(view).to receive(:can?).and_return(false)
    allow(view).to receive(:website).and_return(@website)
    render
  end

  describe "news" do
    it "should link to current news" do
      expect(rendered).to have_link(@news.title, href: news_path(@news))
    end

    it "should hide future news" do
      expect(rendered).not_to have_link(@future_news.title)
    end
  end

end
