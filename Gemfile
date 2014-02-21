source 'http://rubygems.org'

gem 'rails', '3.2.17'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "zurb-foundation", "~> 4.2.1"
end

gem 'jquery-rails' 
gem 'capistrano', '2.13.5' # 2.14.1 causes tinymce assets to be deleted
gem 'capistrano-ext'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'mysql2', '>= 0.3.12b4' # sphinx needs '0.3.12b4'
gem "friendly_id", "~> 3.0"
gem 'aws-sdk', '~> 1.0'
gem "paperclip", "~> 3.0"
gem 'paperclip-meta'
gem 'meta-tags', require: 'meta_tags'
gem 'tinymce-rails', '~> 3.5'
gem 'geokit', '1.7.1'
gem 'geokit-rails'
gem 'api_cache'
gem 'moneta'
gem 'geocoder_plus'
# gem 'geoip', git: 'http://github.com/cjheath/geoip.git'
gem 'thinking-sphinx', '~> 3.0'
gem 'youtube_it', "~> 2.2"
gem 'twitter'
gem 'delayed_job_active_record'
gem 'devise' 
gem 'cancan'
gem 'gravtastic'
gem "recaptcha", require: "recaptcha/rails"
gem 'to_xls'
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'dynamic_form'
gem 'rails_autolink'
gem 'swf_fu', '>=1.3.4', require: 'swf_fu'
gem 'execjs'
gem 'therubyracer' 
gem 'rubyzip', require: 'zip'
gem 'whenever' #, require: false
gem "simple_form", ">= 2.0.2"
gem 'country_select'
gem 'ransack'
gem "dalli"
gem "rabl"
gem "money", "~> 5.1.1"
gem 'money-rails'
gem 'will_paginate'
# gem 'rack-rewrite'
gem "bing_translator" #, "~> 3.2.0"
gem "possessive"
gem 'event-calendar', :require => 'event_calendar'
gem 'RedCloth'
gem 'figaro'
gem 'puma'
gem 'delayed_paperclip'

### Could be useful in the future...
# gem "bing_translate_yaml", "~> 0.1.7" 

### New Sound Community stuff
# gem 'forem', git: "http://github.com/radar/forem.git"
# gem 'forem-theme-twist', git: "http://github.com/radar/forem-theme-twist.git"

group :production, :staging do
  gem 'daemons'
  gem 'passenger_monit'
  gem "exception_notification"
end

group :development do
  # gem 'bullet'
  # gem 'rack-mini-profiler'
end

group :development, :test do
  gem 'unicorn'
  gem 'minitest-rails'
  gem "factory_girl_rails"
  gem 'zeus'
end

group :test do
  gem 'turn'
  gem 'mocha', require: false
  gem 'minitest-rails-capybara'
  gem 'minitest-capybara', '0.1.0' # 0.3.0 broke stuff
  gem "minitest-wscolor"
  gem 'capybara-webkit'
  gem 'launchy' # save_and_open_page inline in tests
  gem 'minitest' #, '2.12.1'
  gem 'guard-minitest'
  gem 'rb-fsevent', :require => false 
  gem 'rb-inotify', '~> 0.9', :require => false 
  gem 'database_cleaner'
end
