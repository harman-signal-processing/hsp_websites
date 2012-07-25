class Tweet < ActiveRecord::Base
  belongs_to :brand
  attr_accessible :brand_id, :content, :posted_at, :profile_image_url, :screen_name, :tweet_id

  def self.pull_tweets(brand)
  	if twitter_name = brand.twitter_name
	  Twitter.user_timeline(twitter_name, since: 1.month.ago).each do |tweet|
        unless exists?(tweet_id: tweet.id)
      	  create!(
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
