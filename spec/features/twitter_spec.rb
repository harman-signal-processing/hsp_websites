require "rails_helper"

feature "Twitter" do

  before :all do
    @brand = FactoryGirl.create(:brand)
    @website = FactoryGirl.create(:website, brand: @brand)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  before :each do
    allow(@brand).to receive(:twitter_name).and_return('adamtao')
  end
  # after :each do
  #   DatabaseCleaner.clean
  # end

  # These tests actually hit twitter to test that it works. Might be overkill, but
  # I've had problems with the twitter gem changing drastically between versions
  # causing things to stop working.
  describe "homepage feed" do
  	before do
  	  @tweet_count = Tweet.count
  	  Tweet.pull_tweets(@brand)
  	end

  	it "should store tweets in db" do
      expect(Tweet.count).not_to equal(@tweet_count)
  	end

  	# it "should show the tweets on the homepage" do
  	#   skip "I think the auto_link method in the view causes this to not match"
  	#   page.must_have_content(@website.recent_tweets.first.content)
  	# end

  	#it "should show the profile image on the homepage" do
    #  @brand = digitech_brand
    #  @website = digitech_site
  	#  visit root_url(locale: I18n.default_locale, host: @website.url)
  	#  page.must_have_xpath("//img[@src='#{Tweet.client.user(@brand.twitter_name).profile_image_url(:mini)}']")
  	#end
  end

  describe Twitter::User do
    it "should pull a profile_image_url" do
      img = Tweet.client.user('twitter').profile_image_url(:mini)
      expect(img).to match(/http/)
    end
  end

  describe Twitter::Client do
    it "should pull a user_timeline" do
      timeline = Tweet.client.user_timeline('twitter', since: 1.month.ago)

      expect(timeline).to be_an(Array)
      expect(timeline.size).not_to eq(0)
      expect(timeline.first).to respond_to(:id)
    end
  end

end
