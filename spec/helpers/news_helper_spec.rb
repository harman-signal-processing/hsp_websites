require "rails_helper"

RSpec.describe NewsHelper do

  before :all do
    @news = FactoryBot.build_stubbed(:news)
  end

  describe "interchange_news_thumbnail" do
    it "returns html with data-interchange cotnent" do
      img = helper.interchange_news_thumbnail(@news)

      expect(img).to have_xpath("//img[@data-interchange]")
    end
  end

  describe "quote_or_headline" do
    it "should revert to headline when quote empty" do
      @news.quote = ""

      expect(helper.quote_or_headline(@news)).to eq @news.title
    end

    it "should use the quote when present" do
      @news.quote = "Clever quote goes here."

      expect(helper.quote_or_headline(@news)).to eq @news.quote
    end
  end
end
