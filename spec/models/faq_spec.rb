require "rails_helper"

RSpec.describe Faq, :type => :model do

  before do
    @faq = FactoryBot.build_stubbed(:faq)
  end

  subject { @faq }
  it { should respond_to(:product) }
  it { should respond_to(:faq_categories) }

  describe "without a product" do
    it "should generate a valid sort_key" do
      expect(@faq.sort_key).to eq(@faq.question)
    end
  end

  describe "with an invalid product id" do
    it "should still generate a valid sort_key" do
      @faq.product_id = 999999

      expect(@faq.sort_key).to eq(@faq.question)
    end
  end

  describe "with a valid product id" do
    it "should generate a sort_key including the product name" do
      product = FactoryBot.build_stubbed(:product)
      @faq.product = product

      expect(@faq.sort_key).to match(product.name.downcase)
    end
  end

  describe "with a category id" do
    it "should be valid" do
      faq_category = FactoryBot.create(:faq_category)
      faq = Faq.new(question: "Why?", answer: "Becuz", faq_category_ids: [faq_category.id])

      is_valid = faq.valid?

      expect(is_valid).to be(true)
    end
  end
end
