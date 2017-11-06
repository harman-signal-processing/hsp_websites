require 'rails_helper'

# Feature: Visit the FAQ page
#   As a site visitor
#   I want to read answers to questions
#   So that I can avoid calling tech support and use my product
feature "Visit FAQ page" do
  before do
    @website = FactoryBot.create(:website)
    @faq = FactoryBot.create(:faq)
    @faq_category = FactoryBot.create(:faq_category, brand: @website.brand)
    @faq_category.faqs << @faq

    visit faqs_url(host: @website.url)
  end

  scenario "and see general support topics" do
    click_on @faq_category.name
    click_on @faq.question

    expect(page).to have_content(@faq.question)
    expect(page).to have_content(@faq.answer)
  end

end
