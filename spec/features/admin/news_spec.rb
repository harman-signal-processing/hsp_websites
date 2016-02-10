require "rails_helper"

feature "Admin News", :devise do

  before :all do
    @website = FactoryGirl.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryGirl.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
  end

  before :each do
    admin_login_with(@user.email, "password", @website)
    click_on "News"
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

      expect(page).to have_content news_title
      expect(page).to have_link news_url(News.last, locale: I18n.default_locale, host: @website.url)
      expect(News.count).to eq(old_news + 1)
    end

    it "should require a date for new news" do
      old_news = News.count
      news_title = "Giant meatballs fall from outerspace #{rand()}"

      fill_in :news_title, with: news_title
      fill_in :news_body, with: "Story goes here."
      click_on "Create"

      expect(page).not_to have_content news_title
      expect(News.count).to eq(old_news)
    end

  end

end
