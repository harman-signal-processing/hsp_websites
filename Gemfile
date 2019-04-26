source 'http://rubygems.org'

gem 'rails', '~> 5.2'
gem 'responders', '~> 2.0'
# Gems used only for assets and not required
# in production environments by default.
gem 'sprockets'
gem 'sprockets-rails'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem "foundation-rails", '5.5.1' # 5.5.3 has a bug with Magellan https://github.com/zurb/foundation-sites/issues/8416
gem 'lightbox2-rails', '~> 2.7.1' # 6/1/2016 v2.8.2.1 stopped working.
gem 'image_zoomer'
gem 'jquery-rails'
gem 'font-awesome-rails'
# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
gem 'mysql2' , '< 0.4.7' # internal server wouldn't install 0.4.7
gem 'utf8-cleaner'
gem 'friendly_id', '>= 5.2'
#gem 'aws-sdk', '< 3' # v3 modularizes AWS services, tough to work with paperclip
gem 'aws-sdk-s3' # modularized AWS service, only S3 needed
gem 'fog-core', '< 2.1.1' # fog-rackspace isn't working with fog-core after 2.1.0
gem 'fog-rackspace'
gem 'fog-aws'
gem 'asset_sync'
gem "paperclip" #, '< 6.0'
gem 'paperclip-meta'
gem 's3_direct_upload'
gem 'meta-tags'
gem 'tinymce-rails',
  git: 'https://github.com/spohlenz/tinymce-rails.git',
  ref: '4cbaab8b885cc4ba800cec88377733cba8a12e2f'
gem 'mechanize'
gem 'geokit', '>= 1.8.5'
gem 'geokit-rails'
gem 'thinking-sphinx', '~> 4.0'
gem 'google-api-client', '~> 0.8.6', require: 'google/api_client'
gem 'twitter', '~> 5.1'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'httparty'
gem 'devise'
gem 'cancancan'
gem 'gravtastic'
gem "recaptcha", require: "recaptcha/rails"
gem 'to_xls-rails'
gem 'acts_as_list'
gem 'acts_as_tree'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'dynamic_form'
gem 'rails_autolink'
gem 'swf_fu', '>=1.3.4', require: 'swf_fu'
gem 'execjs'
gem 'therubyrhino'
gem 'rubyzip', require: 'zip'
gem 'whenever' #, require: false
gem "simple_form", ">= 2.0.2"
gem 'country_select' #, '~> 1.3.1' # v2+ switches to store 2-letter ISO for country which breaks our current setup
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
  ref: 'acd94832693989e03e239095e6071668c34a7ff4'
gem "possessive"
gem 'RedCloth'
gem 'figaro'
gem 'delayed_paperclip'
gem 'cheetah_mail', "~> 0.6.0"
gem 'silverpop'
gem 'hashie', '~> 3.4.6' # 3.5.1 was causing errors with some silverpop transactions
gem 'oauth2'
gem 'rmagick', "< 3.0", require: 'rmagick' #v3+ requires ImageMagick >= 6.8
gem 'typhoeus' # For link validator
gem 'slick_rails' # slick carousel
gem 'mailgun_rails' # mailer service
gem 'nokogiri'
gem 'email_validator'

group :production, :staging do
  gem 'passenger_monit'
  gem "exception_notification"
end

group :development do
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
end

group :development, :test do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rspec-rails'
  gem "factory_bot_rails" #, "~> 4.0"
  gem 'pry-byebug'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'json-schema'
  gem 'faker'
end
