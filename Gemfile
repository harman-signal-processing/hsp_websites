source 'https://rubygems.org'

# Passenger is picky that these versions match those in the server's root gems:
gem "strscan", "3.0.4"
gem "digest", "3.1.0"

gem 'rails', '~> 7.0'
# Github has rails 6.1 support
gem 'actionpack-action_caching', git: 'https://github.com/rails/actionpack-action_caching'
gem 'responders'
gem 'bootsnap', require: false
gem 'sprockets'
gem 'sprockets-rails'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem "foundation-rails", '5.5.1' # 5.5.3 has a bug with Magellan https://github.com/zurb/foundation-sites/issues/8416
gem 'jquery-rails'
gem 'lazyload-rails'
gem 'font-awesome-rails'
# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'mysql2'
gem 'utf8-cleaner'
gem 'friendly_id', '>= 5.2'
gem 'aws-sdk-s3'
gem 'fog-core'
gem 'fog-aws'
gem 'asset_sync'
gem "kt-paperclip", ">= 7.0"
gem 'kt-paperclip-compression'
gem 'kt-delayed_paperclip'
gem 's3_direct_upload'
gem 'meta-tags'
gem 'tinymce-rails',
  git: 'https://github.com/spohlenz/tinymce-rails.git',
  ref: '4cbaab8b885cc4ba800cec88377733cba8a12e2f'
gem 'mechanize'
gem 'geokit', '>= 1.8.5'
gem 'geokit-rails'
gem 'thinking-sphinx'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'httparty'
gem 'devise'
gem 'devise-async'
gem 'cancancan'
gem 'gravtastic'
gem "recaptcha", require: "recaptcha/rails"
gem 'to_xls-rails'
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'acts-as-taggable-on'
gem 'dynamic_form'
gem 'rails_autolink'
gem 'execjs'
gem 'therubyrhino'
gem 'whenever' #, require: false
gem "simple_form", ">= 5.0.0"
gem 'country_select'
gem 'chosen-rails'
gem 'language_list'
gem 'ransack'
gem "dalli"
gem "rabl"
gem "money"
gem 'money-rails', ">= 1.9.0" # 2017-12-01
gem 'will_paginate'
gem 'will_paginate_infinite',
  git: 'https://github.com/adamtao/will_paginate_infinite.git',
  branch: 'master'

gem "possessive"
gem 'RedCloth'
gem 'figaro'
gem 'goacoustic'
gem 'oauth2'
gem 'typhoeus' # For link validator
gem 'slick_rails' # slick carousel
gem 'mailgun_rails' # mailer service
gem 'nokogiri', '>= 1.13.4'
gem 'email_validator'
gem "exception_notification"
gem 'slack-notifier'
gem 'google-api-client', '~> 0.36'
gem 'wicked_pdf'

group :production, :staging do
  gem 'passenger_monit'
end

group :development do
  gem 'brakeman'
  gem 'bumbler'
  gem 'web-console' #, '~> 2.0'
  gem 'capistrano', '~> 3'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
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
  gem 'rorvswild'
  gem 'marginalia'
  gem 'active_record_query_trace'
end

group :development, :test do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem "factory_bot_rails", "~> 6.0"
  gem 'pry'#, "0.12.2"
  gem 'pry-byebug'
end

group :test do
  gem 'capybara'
  gem 'webdrivers'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'json-schema'
  gem 'faker'
end
