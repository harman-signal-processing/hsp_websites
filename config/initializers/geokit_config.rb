# Include a little hack to get things working with Rails3
#  require Rails.root.join('lib', 'merge_conditions.rb')

# For geocoder_plus
# require 'api_cache'
# require 'moneta'
# require 'moneta/adapters/memcached'
# if Rails.env.production? || Rails.env.staging?
#   Geokit::Geocoders::api_cache         = 604800
#   Geokit::Geocoders::api_cache_valid   = :forever
#   Geokit::Geocoders::api_cache_timeout = 5
#   APICache.store = Moneta::Adapters::MemcachedDalli.new(server: "localhost:11211", expires: 1.day, namespace: 'geokit')
# end

# These defaults are used in Geokit::Mappable.distance_to and in acts_as_mappable
Geokit::default_units = :miles
Geokit::default_formula = :sphere

# This is the timeout value in seconds to be used for calls to the geocoder web
# services.  For no timeout at all, comment out the setting.  The timeout unit
# is in seconds.
Geokit::Geocoders::request_timeout = 6

# These settings are used if web service calls must be routed through a proxy.
# These setting can be nil if not needed, otherwise, addr and port must be
# filled in at a minimum.  If the proxy requires authentication, the username
# and password can be provided as well.

#unless (Rails.env.production? || Rails.env.staging?)
#  Geokit::Geocoders::proxy = 'http://10.10.68.244:8080'
#end

# This is your yahoo application key for the Yahoo Geocoder.
# See http://developer.yahoo.com/faq/index.html#appid
# and http://developer.yahoo.com/maps/rest/V1/geocode.html
Geokit::Geocoders::YahooGeocoder.key = ENV['GEOKIT_YAHOO_CONSUMER_KEY']
Geokit::Geocoders::YahooGeocoder.secret = ENV['GEOKIT_YAHOO_CONSUMER_SECRET']

#   # This is your Google Maps geocoder key.
#   # See http://www.google.com/apis/maps/signup.html
#   # and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
#   Geokit::Geocoders::google = ENV['GEOKIT_GOOGLE']

# This is your Google Maps geocoder keys (all optional).
# See http://www.google.com/apis/maps/signup.html
# and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
Geokit::Geocoders::GoogleGeocoder.client_id = ENV['GEOKIT_GOOGLE']
Geokit::Geocoders::GoogleGeocoder.cryptographic_key = ''
Geokit::Geocoders::GoogleGeocoder.channel = ''

# You can also set multiple API KEYS for different domains that may be directed to this same application.
# The domain from which the current user is being directed will automatically be updated for Geokit via
# the GeocoderControl class, which gets it's begin filter mixed into the ActionController.
# You define these keys with a Hash as follows:
#Geokit::Geocoders::google = { 'rubyonrails.org' => 'RUBY_ON_RAILS_API_KEY', 'ruby-docs.org' => 'RUBY_DOCS_API_KEY' }

# This is your username and password for geocoder.us.
# To use the free service, the value can be set to nil or false.  For
# usage tied to an account, the value should be set to username:password.
# See http://geocoder.us
# and http://geocoder.us/user/signup
# Geokit::Geocoders::UsGeocoder.key = 'username:password'

# This is your authorization key for geocoder.ca.
# To use the free service, the value can be set to nil or false.  For
# usage tied to an account, set the value to the key obtained from
# Geocoder.ca.
# See http://geocoder.ca
# and http://geocoder.ca/?register=1
# Geokit::Geocoders::CaGeocoder.key = 'KEY'

# Most other geocoders need either no setup or a key
Geokit::Geocoders::BingGeocoder.key = ENV['GEOKIT_BING']
Geokit::Geocoders::GeonamesGeocoder.key = ENV['GEOKIT_GEONAMES']
# Geokit::Geocoders::MapQuestGeocoder.key = ''
# Geokit::Geocoders::YandexGeocoder.key = ''

# require "external_geocoder.rb"
# Please see the section "writing your own geocoders" for more information.
# Geokit::Geocoders::external_key = 'REPLACE_WITH_YOUR_API_KEY'

# This is the order in which the geocoders are called in a failover scenario
# If you only want to use a single geocoder, put a single symbol in the array.
# Valid symbols are :google, :yahoo, :us, and :ca.
# Be aware that there are Terms of Use restrictions on how you can use the
# various geocoders.  Make sure you read up on relevant Terms of Use for each
# geocoder you are going to use.
Geokit::Geocoders::provider_order = [:bing, :google] #:geonames] #, :yahoo, :google]

# The IP provider order. Valid symbols are :ip,:geo_plugin.
# As before, make sure you read up on relevant Terms of Use for each.
# Geokit::Geocoders::ip_provider_order = [:external,:geo_plugin,:ip]

# Disable HTTPS globally.  This option can also be set on individual
# geocoder classes.
Geokit::Geocoders::secure = true

# Control verification of the server certificate for geocoders using HTTPS
Geokit::Geocoders::ssl_verify_mode = OpenSSL::SSL::VERIFY_NONE
# Setting this to VERIFY_NONE may be needed on systems that don't have
# a complete or up to date root certificate store. Only applies to
# the Net::HTTP adapter.
