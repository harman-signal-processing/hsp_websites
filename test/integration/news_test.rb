require "minitest_helper"

describe "News Integration Test" do

  before do
    DatabaseCleaner.start
    @website = FactoryGirl.create(:website_with_products)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
    @news_story = FactoryGirl.create(:news, brand: @website.brand)
  end
  
  describe "current news list" do
  	it "should link to news story" do
  		visit news_index_url(locale: I18n.default_locale, host: @website.url)
  		page.must_have_link @news_story.title, href: news_path(@news_story, locale: I18n.default_locale) 
  	end
  end

  describe "news story view" do
  	before do
  		Website.any_instance.stubs(:show_comparisons).returns("1")
	    @product = @website.products.first
	    FactoryGirl.create(:news_product, news: @news_story, product: @product)
  		visit news_url(@news_story, locale: I18n.default_locale, host: @website.url)
  	end

  	it "should link to related products" do
  		page.must_have_link @product.name, href: product_url(@product, locale: I18n.default_locale, host: @website.url)
  	end

  	it "should NOT have a compare checkbox" do
  		page.wont_have_css("#product_ids_[value='#{@product.to_param}']")
  	end
  end

  describe "product page" do 
    before do
      @product = @website.products.first
    end

    it "should link to current news" do
      FactoryGirl.create(:news_product, news: @news_story, product: @product)
      visit product_url(@product, locale: I18n.default_locale, host: @website.url)
      page.must_have_link @news_story.title, href: news_path(@news_story, locale: I18n.default_locale)
    end
 
    it "should hide future news" do
      @news_story = FactoryGirl.create(:news, brand: @website.brand, post_on: 1.month.from_now, title: "Future News")
      FactoryGirl.create(:news_product, news: @news_story, product: @product)
      visit product_url(@product, locale: I18n.default_locale, host: @website.url)
      page.wont_have_link @news_story.title
    end
  end

  describe "future news story" do
    before do
      @news_story = FactoryGirl.create(:news, brand: @website.brand, post_on: 1.month.from_now, title: "Future News")
    end

    it "should not appear on the index" do
      visit news_index_url(locale: I18n.default_locale, host: @website.url)
      page.wont_have_link @news_story.title
    end

    it "link should redirect to the index" do
      visit news_url(@news_story, locale: I18n.default_locale, host: @website.url)
      current_path.must_equal(news_index_path(locale: I18n.default_locale))
    end

  end

  describe "old news" do
  	before do
      # Create at least 5 'current' news stories so that the archives appear
      FactoryGirl.create_list(:news, 10, brand: @website.brand)
  		@old_news = FactoryGirl.create(:old_news, brand: @website.brand)
  		visit news_index_url(locale: I18n.default_locale, host: @website.url)
  	end

  	it "should not appear on current news list" do
  		page.wont_have_link @old_news.title
  	end

  	it "should link to archived news page" do
  		page.must_have_link "older", href: archived_news_index_path(locale: I18n.default_locale)
  	end

  	it "should link to the old news from the archived page" do
  		click_link "older"
  		page.must_have_link @old_news.title, href: news_path(@old_news, locale: I18n.default_locale)
  	end
  end

end