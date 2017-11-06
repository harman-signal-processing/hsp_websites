require "rails_helper"

RSpec.describe AdminHelper do

  before :all do
    @website = FactoryBot.create(:website_with_products)
  end

  describe "link_to_translate" do
    it "returns a link" do
      product = @website.products.first
      allow(helper).to receive(:website).and_return(@website)

      content = helper.link_to_translate(product)

      expect(content).to have_link(product.name)
    end
  end

  describe "name_for" do
    it "returns the .name" do
      product = @website.products.first

      expect(helper.name_for(product)).to eq(product.name)
    end

    it "returns a news title" do
      news = FactoryBot.build_stubbed(:news)

      expect(helper.name_for(news)).to eq(news.title)
    end

    it "returns a question" do
      faq = FactoryBot.build_stubbed(:faq, product: @website.products.first)

      expect(helper.name_for(faq)).to match(faq.question)
    end

    # Some object that doesn't have a name, title, or question
    it "returns an object's param value" do
      expect(helper.name_for(@website)).to eq(@website.to_param)
    end
  end

end
