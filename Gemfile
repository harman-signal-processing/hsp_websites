source 'http://rubygems.org'

gem 'rails', '4.2.5'
gem 'responders', '~> 2.0'
# Gems used only for assets and not required
# in production environments by default.
gem 'sprockets' #, '< 3.0' # v3.0 caused deploy problems with capistrano as of 4/15/15
gem 'sprockets-rails' #, '2.2.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem "foundation-rails", '~> 5.5'
gem 'lightbox2-rails'
gem 'jquery-rails'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'mysql2', '~> 0.3.18' # sphinx needs '0.3.12b4'
gem 'utf8-cleaner'
gem "friendly_id"
gem 'aws-sdk', '< 2.0'
gem 'fog'
gem 'asset_sync'
gem "paperclip" #, "~> 3.0"
gem 'paperclip-meta'
gem 's3_direct_upload'
gem 'meta-tags', '~> 1.5', require: 'meta_tags' # v 2.0.0 caused an error
gem 'tinymce-rails', git: 'https://github.com/spohlenz/tinymce-rails.git'
gem 'mechanize'
gem 'geokit', '>= 1.8.5'
gem 'geokit-rails'
gem 'thinking-sphinx', '~> 3.0'
gem 'google-api-client', require: 'google/api_client'
gem 'twitter', '~> 5.1'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'devise'
gem 'cancan'
gem 'gravtastic'
gem "recaptcha", require: "recaptcha/rails"
gem 'to_xls-rails'
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'dynamic_form'
gem 'rails_autolink'
gem 'swf_fu', '>=1.3.4', require: 'swf_fu'
gem 'execjs'
gem 'therubyrhino'
gem 'rubyzip', require: 'zip'
gem 'whenever' #, require: false
gem "simple_form", ">= 2.0.2"
gem 'country_select', '~> 1.3.1' # v2+ switches to store 2-letter ISO for country which breaks our current setup
gem 'ransack'
gem "dalli"
gem "rabl"
gem "money"
gem 'money-rails'
gem 'will_paginate'
gem "bing_translator"
gem "rubyntlm" # optional dependency for bing_translator, but causes log errors without it
gem "possessive"
#gem 'event-calendar', :require => 'event_calendar' # was for marketing queue, I think
gem 'RedCloth'
gem 'figaro'
gem 'delayed_paperclip'
gem 'cheetah_mail', "~> 0.6.0"
gem 'rmagick', require: 'rmagick'
gem 'typhoeus' # For link validator
gem 'slick_rails' # slick carousel

### Could be useful in the future...
# gem "bing_translate_yaml", "~> 0.1.7"

### New Sound Community stuff
# gem 'forem', git: "http://github.com/radar/forem.git"
# gem 'forem-theme-twist', git: "http://github.com/radar/forem-theme-twist.git"

group :production, :staging do
  gem 'passenger_monit'
  gem "exception_notification"
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'capistrano', '~> 3.4', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-delayed-job', '~> 1.0'
  gem 'capistrano-passenger'
  # gem 'rack-mini-profiler'
  gem 'letter_opener'
  gem 'spring'

  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'sshkit'
  gem 'colorize'
end

group :development, :test do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem "factory_girl_rails", "~> 4.0"
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'json-schema'
  gem 'faker'
end
