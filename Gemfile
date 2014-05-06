source 'http://rubygems.org'

gem 'rails', '3.2.17'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'turbo-sprockets-rails3' # don't precompile assets which haven't changed
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "zurb-foundation", "~> 4.3.2"
  gem 'asset_sync'
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
gem 'fog' # for rackspace cloud files
gem "paperclip" #, "~> 3.0"
gem 'paperclip-meta'
gem 's3_direct_upload'
gem 'meta-tags', '~> 1.5', require: 'meta_tags' # v 2.0.0 caused an error
gem 'tinymce-rails', '~> 3.5'

# 3/1/2014 This commit of the geokit api uses HTTPS properly--which is required by providers (release gem is not updated yet)
gem 'geokit', git: 'https://github.com/geokit/geokit.git', ref: '23c4c6a202671107dbdbd2dd1d8dc69dd8649a45'
gem 'geokit-rails'
gem 'thinking-sphinx', '~> 3.0'

# 4/7/2014 This commit of youtube has the new api (v3) working, also depends on json ~> 1.8 (released gem is not updated yet)
gem 'youtube_it', git: 'https://github.com/kylejginavan/youtube_it.git', ref: '943a202fce2324d5122f80396e3bc473a61dc4c4' #'~> 2.4.0'
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
gem "money"
gem 'money-rails'
gem 'will_paginate'
gem "bing_translator"
gem "possessive"
gem 'event-calendar', :require => 'event_calendar'
gem 'RedCloth'
gem 'figaro'
gem 'delayed_paperclip'
gem 'cheetah_mail', "~> 0.6.0"
gem 'rmagick', :require => 'RMagick'

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
  # gem 'rack-mini-profiler'
end

group :development, :test do
  # gem 'bullet'
  # gem 'unicorn'
  gem 'minitest-rails'
  gem "factory_girl_rails"
  gem 'zeus'
end

group :test do
  gem 'turn'
  gem 'mocha', require: false
  gem 'minitest-rails-capybara'
  gem 'minitest-capybara'
  gem "minitest-wscolor"
  gem 'capybara-webkit'
  gem 'launchy' # save_and_open_page inline in tests
  gem 'minitest'
  gem 'guard-minitest'
  gem 'rb-fsevent', :require => false 
  gem 'rb-inotify', '~> 0.9', :require => false 
  gem 'database_cleaner'
end
