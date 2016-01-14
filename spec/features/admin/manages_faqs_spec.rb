require "rails_helper"

feature "Managing FAQs", :devise do

  before :all do
    @website = FactoryGirl.create(:website)
    @user = FactoryGirl.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
  end

  before :each do
    admin_login_with(@user.email, "password", @website)
    click_on "FAQs"
  end

  scenario "create an FAQ category" do
    start_categories = FaqCategory.count
    click_on "New Category"

    fill_in "Name", with: "Foobar Category"
    click_on "Create"

    expect(FaqCategory.count).to be > start_categories
    expect(page).to have_content("Category was successfully created.")
    expect(page).to have_link("New FAQ")
  end

  scenario "create an FAQ belonging to a category" do
    category = FactoryGirl.create(:faq_category, brand: @website.brand)
    start_faqs = Faq.count
    click_on "New FAQ"

    fill_in "Question", with: "Why are the amps so wonderful?"
    fill_in "Answer", with: "Because they're made with love."
    select category.name, from: "Faq categories"
    click_on "Create"

    category.reload
    expect(category.faqs.length).to eq(1)
    expect(Faq.count).to be > start_faqs
    expect(page).to have_link category.name, href: admin_faq_category_path(category, locale: I18n.default_locale)
  end
end
