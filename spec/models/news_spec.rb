require "rails_helper"

RSpec.describe News, :type => :model do

  before do
    @news = FactoryBot.build_stubbed(:news)
  end

  subject { @news }
  it { should respond_to(:title) }
  it { should respond_to(:brand) }
  it { should respond_to(:quote) }

  describe "#quote_or_headline" do
    it "should revert to headline when quote empty" do
      @news.quote = ""

      expect(@news.quote_or_headline).to eq @news.title
    end

    it "should use the quote when present" do
      @news.quote = "Clever quote goes here."

      expect(@news.quote_or_headline).to eq @news.quote
    end
  end

end
