require "minitest_helper"

describe "Twitter Integration Test" do

  before do
    DatabaseCleaner.start
    @brand = FactoryGirl.create(:brand)
    Brand.any_instance.stubs(:twitter_name).returns('DigiTech')
    @website = FactoryGirl.create(:website_with_products, brand: @brand)
    host! @website.url
    Capybara.default_host = "http://#{@website.url}" 
    Capybara.app_host = "http://#{@website.url}" 
  end

  # These tests actually hit twitter to test that it works. Might be overkill, but
  # I've had problems with the twitter gem changing drastically between versions
  # causing things to stop working.
  describe "homepage feed" do
  	before do
  	  @tweet_count = Tweet.count
  	  Tweet.pull_tweets(@brand)  		
  	end

  	it "should store tweets in db" do
  	  Tweet.count.wont_equal(@tweet_count)
  	end

  	it "should show the tweets on the homepage" do
  	  skip "I think the auto_link method in the view causes this to not match"
  	  page.must_have_content(@website.recent_tweets.first.content)
  	end

  	it "should show the profile image on the homepage" do
  	  visit root_url(locale: I18n.default_locale, host: @website.url)
  	  page.must_have_xpath("//img[@src='#{Twitter.user(@brand.twitter_name).profile_image_url(:mini)}']")
  	end

  end

end