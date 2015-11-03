require "rails_helper"

RSpec.describe NewsHelper do

  before :all do
    @news = FactoryGirl.build_stubbed(:news)
  end

  describe "interchange_news_thumbnail" do
    it "returns html with data-interchange cotnent" do
      img = helper.interchange_news_thumbnail(@news)

      expect(img).to have_xpath("//img[@data-interchange]")
    end
  end
end
