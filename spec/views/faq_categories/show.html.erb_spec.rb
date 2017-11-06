require 'rails_helper'

RSpec.describe "faq_categories/show.html.erb", :type => :view do
  before do
    @faq_category = FactoryBot.create(:faq_category)
    @faq = FactoryBot.create(:faq)
    @faq_category.faqs << @faq

    assign(:faq_category, @faq_category)
    render
  end

  it "lists the category's faqs" do
    expect(rendered).to have_link(@faq.question)
    expect(rendered).to have_content(@faq.answer)
  end
end
