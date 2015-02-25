require 'rails_helper'

RSpec.describe FaqCategory, :type => :model do

  before do
    @faq_category = FactoryGirl.build_stubbed(:faq_category)
  end

  subject { @faq_category }
  it { should respond_to(:brand) }

  it "has faqs" do
    faq = FactoryGirl.create(:faq)

    @faq_category.faqs << faq

    expect(@faq_category.faqs).to include(faq)
  end
end
