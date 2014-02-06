require "test_helper"

describe "Admin News Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    @brand = FactoryGirl.create(:digitech_brand)
    @website = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @brand, url: "digitech.lvh.me")
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
    
    @user = FactoryGirl.create(:user, market_manager: true, password: "password")
    admin_login_with(@user, "password", @website)
    click_on "News"
  end

  after :each do
    DatabaseCleaner.clean
  end

  describe "Creating news" do

    before do 
      click_on "New news"
    end

    it "should create new news" do
      old_news = News.count 
      news_title = "Giant meatballs fall from outerspace #{rand()}"
      fill_in :news_post_on, with: Date.today
      fill_in :news_title, with: news_title
      fill_in :news_body, with: "Story goes here."
      click_on "Create"
      must_have_content news_title
      must_have_link news_url(News.last, locale: I18n.default_locale)
      News.count.must_equal(old_news + 1)
    end

    it "should require a date for new news" do
      old_news = News.count 
      news_title = "Giant meatballs fall from outerspace #{rand()}"
      fill_in :news_title, with: news_title
      fill_in :news_body, with: "Story goes here."
      click_on "Create"
      wont_have_content news_title
      News.count.must_equal(old_news)
    end

  end

end