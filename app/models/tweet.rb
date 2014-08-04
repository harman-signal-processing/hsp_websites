class Tweet < ActiveRecord::Base
  belongs_to :brand
  # attr_accessible :brand_id, :content, :posted_at, :profile_image_url, :screen_name, :tweet_id
  validates :tweet_id, presence: true, uniqueness: true

  def self.client
    @client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_OAUTH_TOKEN']
      config.access_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
    end
  end
  
  def self.pull_tweets(brand)
  	if twitter_name = brand.twitter_name
	  Tweet.client.user_timeline(twitter_name, since: 1.week.ago).each do |tweet|
        unless exists?(tweet_id: tweet.id.to_s)
      	  create(
        		tweet_id: tweet.id,
        		content: tweet.text,
        		screen_name: tweet.user.screen_name,
        		profile_image_url: tweet.user.profile_image_url,
        		posted_at: tweet.created_at,
        		brand_id: brand.id
      	  )
      	end
      end
    end
  end

end
