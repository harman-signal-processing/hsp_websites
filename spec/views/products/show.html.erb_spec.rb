require 'rails_helper'

RSpec.describe "products/show.html.erb", :type => :view do
  before do
    @website = FactoryGirl.create(:website_with_products)
    @product = FactoryGirl.create(:product, brand: @website.brand)
    @news = FactoryGirl.create(:news, brand: @website.brand)
    @future_news = FactoryGirl.create(:news, brand: @website.brand, post_on: 1.month.from_now, title: "Future News")
    @product.news += [@news, @future_news]

    allow(view).to receive(:current_user).and_return(User.new)
    allow(view).to receive(:can?).and_return(false)
    allow(view).to receive(:website).and_return(@website)
    assign(:product, @product)
    render
  end

  describe "news" do
    it "should link to current news" do
      expect(rendered).to have_link(@news.title, news_path(@news))
    end

    it "should hide future news" do
      expect(rendered).not_to have_link(@future_news.title)
    end
  end

end
