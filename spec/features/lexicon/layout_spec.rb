require "rails_helper"

feature "Lexicon brand" do

  before :all do
    @brand = FactoryGirl.create(:lexicon_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  before :each do
    visit root_path
  end

  after :all do
    DatabaseCleaner.clean_with :truncation
  end

  scenario "correct layout is used" do
    expect(page).to have_xpath("//body[@data-brand='#{@brand.name}']")
  end

  scenario "should label Artists Professionals" do
    expect(page).to have_link "professionals", href: artists_path(locale: I18n.default_locale)
  end

end
