Twitter.configure do |config|
  config.consumer_key =       ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret =    ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token =        ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end

if (Rails.env.production? || Rails.env.staging?)
  # Twitter.connection_options[:proxy] = ''
else
  Twitter.connection_options[:proxy] = 'http://10.30.26.254:8080'
end