require "rails_helper"

feature "Lexicon brand" do

  before :all do
    @brand = FactoryBot.create(:lexicon_brand)
    @website = FactoryBot.create(:website, folder: "lexicon", brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  before :each do
    visit root_path
  end

  after :all do
    DatabaseCleaner.clean_with :deletion
  end

  scenario "correct layout is used" do
    expect(page).to have_xpath("//body[@data-brand='#{@brand.name}']")
  end

  scenario "should label Artists Professionals" do
    expect(page).to have_link "Professionals", href: artists_path(locale: I18n.default_locale)
  end

end
