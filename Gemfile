source 'http://rubygems.org'

gem 'rails', '4.2.7.1'
gem 'responders', '~> 2.0'
# Gems used only for assets and not required
# in production environments by default.
gem 'sprockets' #, '< 3.0' # v3.0 caused deploy problems with capistrano as of 4/15/15
gem 'sprockets-rails' #, '2.2.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem "foundation-rails", '~> 5.5'
gem 'lightbox2-rails', '~> 2.7.1' # 6/1/2016 v2.8.2.1 stopped working.
gem 'image_zoomer'
gem 'jquery-rails', "~> 4.0.5" # 4.1 broke buy it now popups

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'mysql2' #, '~> 0.3.18' # sphinx needs '0.3.12b4'
gem 'utf8-cleaner'
gem "friendly_id", "~> 5.1.0" # 5.2.0 had a problem 12/6/2016
gem 'aws-sdk', '< 2.0'
gem 'fog-rackspace'
gem 'fog-aws'
gem 'asset_sync'
gem "paperclip", "4.3.6" # After this, AWS 2 is needed
gem 'paperclip-meta'
gem 's3_direct_upload'
gem 'meta-tags', '~> 1.5', require: 'meta_tags' # v 2.0.0 caused an error
gem 'tinymce-rails',
  git: 'https://github.com/spohlenz/tinymce-rails.git',
  ref: '4cbaab8b885cc4ba800cec88377733cba8a12e2f'
gem 'mechanize'
gem 'geokit', '>= 1.8.5'
gem 'geokit-rails'
gem 'thinking-sphinx', '~> 3.0'
gem 'google-api-client', '~> 0.8.6', require: 'google/api_client'
gem 'twitter', '~> 5.1'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'httparty'
gem 'devise'
gem 'cancan'
gem 'gravtastic'
gem "recaptcha", '~> 1.3', require: "recaptcha/rails"
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
gem 'silverpop'
gem 'hashie', '~> 3.4.6' # 3.5.1 was causing errors with some silverpop transactions
gem 'oauth2'
gem 'rmagick', require: 'rmagick'
gem 'typhoeus' # For link validator
gem 'slick_rails' # slick carousel
gem 'mailgun_rails' # mailer service
gem 'nokogiri'
gem 'email_validator'

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
  gem 'web-console' #, '~> 2.0'
  gem 'capistrano', '3.6.1', require: false # 3.7 error: Don't know how to build task 'deploy:new_release_path'
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
  gem 'test_after_commit' # makes devise 4.1+ work with specs. This won't be needed with rails5
end
