source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'rack', '1.4.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "compass-rails", ">= 1.0.3"
  gem "zurb-foundation", ">= 3.0.9"
end

# jquery-rails 2.1.1 broke the coverflow. Looks like
# it uses jquery 1.8.0, which has a selector bug:
# http://bugs.jquery.com/ticket/12292
gem 'jquery-rails', '~> 2.0.2' # see above, jquery-rails 2.0.2 uses jquery 1.7.2
gem 'capistrano'
gem 'capistrano-ext'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'mysql2' #, "< 0.3"
gem "friendly_id", "~> 3.0"
gem "paperclip", "~> 3.0"
gem 'paperclip-meta' #, git: 'http://github.com/dce/paperclip-meta.git' # 6/27/2012, dce's version fixes a rails 3 issue tha the original author hasn't merged
gem 'meta-tags', require: 'meta_tags'
gem 'tinymce-rails'
gem 'geokit'
gem 'api_cache'
gem 'moneta'
gem 'geocoder_plus'
# gem 'geoip', git: 'http://github.com/cjheath/geoip.git'
gem 'thinking-sphinx', '2.0.10'
gem 'youtube_it'
gem 'twitter'
gem 'daemons'
gem 'delayed_job_active_record'
gem 'devise'
gem 'cancan'
gem "recaptcha", require: "recaptcha/rails"
gem 'to_xls'
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'dynamic_form'
gem 'rails_autolink'
gem 'swf_fu', '>=1.3.4', require: 'swf_fu'
gem 'execjs'
gem 'therubyracer', '=0.10.2' # installs OS dependent gem. Put production version in vendor/cache manually
gem 'rubyzip', require: 'zip/zip'
gem 'whenever' #, require: false
gem "simple_form", ">= 2.0.2"
gem 'country_select'
gem 'rack-mini-profiler'
gem 'ransack'
gem "dalli"
gem "rabl"
gem 'money-rails'
# New Sound Community stuff
#gem 'forem', git: "http://github.com/radar/forem.git"
#gem 'forem-theme-twist', git: "http://github.com/radar/forem-theme-twist.git"
gem 'will_paginate'

group :production, :staging do
  gem 'passenger_monit'
  gem "exception_notification", 
    git: "http://github.com/rails/exception_notification.git",
    require: "exception_notifier"
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'unicorn'
  gem 'minitest-rails', git: "http://github.com/rawongithub/minitest-rails.git", branch: "gemspec"
  gem "factory_girl_rails"
end

group :test do
  gem 'mocha', '= 0.13.0', require: false
  gem 'turn' #, git: "http://github.com/adamtao/turn.git"
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara_minitest_spec'
  gem 'launchy' # save_and_open_page inline in tests
  gem 'minitest' #, '>= 2.12.1' #, '2.11.4 works also. There was a 2.12.? that breaks stuff
  gem 'guard-minitest'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'database_cleaner'
  gem 'minitest-rails-shoulda',
    git: "http://github.com/rawongithub/minitest-rails-shoulda.git",
    ref: "2bd90c19c5be00aa1718a00293b6899223daf79f"
    # Aug 6, 2012 commit changed "Minitest" to "MiniTest" which broke things for me.
    # Probably the next version of "minitest" gem will have the new capitalization
    # and then I'll need to remove the "ref" above.
end