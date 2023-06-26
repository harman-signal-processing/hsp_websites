require 'rails_helper'

feature "Browse News" do

  before :all do
    # using Martin because only it has tag subnav
    @website = create(:website, folder: "martin")
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "news index" do
    let!(:news) { create_list(:news, 2, brands: [@website.brand]) }
    it "links to the story with the news title" do
      visit news_index_path

      expect(page).to have_link news.first.title
      expect(page).to have_link news.last.title
    end
  end

  describe "tag filtering" do
    let!(:news) { create_list(:news, 2, brands: [@website.brand]) }

    it "hides stories not tagged" do
      news.first.tag_list = "possums"
      news.first.save

      visit news_index_path

      select news.first.tags.first.to_s.titleize
      #javascript would redirect, but we'll go to the filtered page directly:
      visit tag_filtered_news_path(tag: news.first.tags.first.to_s)

      expect(page).to have_link news.first.title
      expect(page).not_to have_link news.last.title
    end
  end

  describe "show news story" do
    let!(:news) { create(:news, brands: [@website.brand]) }
    it "shows the story" do
      visit news_path(news, locale: I18n.default_locale)

      expect(page).to have_content(news.title)
    end

    it "redirects to the index if it doesn't belong to the brand" do
      other_brand = create(:brand)
      other_news = create(:news, brands: [other_brand])

      visit news_path(other_news, locale: I18n.default_locale)

      expect(page.current_path).to eq(news_index_path(locale: I18n.default_locale))
    end
  end

  describe "archived news" do
    let!(:news) { create(:news, post_on: 10.years.ago, brands: [@website.brand]) }
    it "shows old stories" do
      visit archived_news_index_path

      expect(page).to have_link(news.title)
    end
  end

  describe "martin redirect for old, imported stories" do
    let!(:martin_news) { create(:news, brands: [@website.brand], old_id: "987", title: "Old Martin News") }
    it "shows the news story" do
      visit(martin_redirect_news_path(martin_news.old_id, locale: I18n.default_locale))

      expect(page).to have_content(martin_news.title)
    end

    it "redirects to news index if story not found" do
      visit(martin_redirect_news_path("CaseStory:666", locale: I18n.default_locale))

      expect(page.current_path).to eq(news_index_path(locale: I18n.default_locale))
    end
  end

  describe "updating a news story" do
    let!(:news) { create(:news, brands: [@website.brand]) }

    it "adds a tag" do
      @user = FactoryBot.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
      admin_login_with(@user.email, "password", @website)

      visit news_path(news.id, locale: I18n.default_locale)

      fill_in :news_tag_list, with: "foober, goober"
      click_on 'Update'

      news.reload
      expect(news.tags.size).to eq(2)
      expect(page).to have_content("foober, goober")
    end
  end
end

