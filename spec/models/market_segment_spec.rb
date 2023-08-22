require "rails_helper"

RSpec.describe MarketSegment, :type => :model do

  before do
    @website = create(:website_with_products)
    @market = create(:market_segment, brand: @website.brand)
    @product = create(:product, brand: @website.brand)
    @product_family = create(:product_family, brand: @website.brand)
    @product_family.products << @product
    @market.product_families << @product_family
  end

  subject { @market }
  it { should respond_to(:brand) }
  it { should respond_to(:product_families) }
  it { should respond_to(:banner_image) }

  describe "related news" do

    it "collects current news" do
      news = FactoryBot.create(:news)
      news.products << @product

      expect(@market.related_news(@website, I18n.locale)).to include(news)
    end

    it "excludes future news" do
      news = FactoryBot.create(:news, post_on: 2.weeks.from_now)
      news.products << @product

      expect(@market.related_news(@website, I18n.locale)).not_to include(news)
    end
  end

end

