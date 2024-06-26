Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.hosts.clear

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  # Note that you may need to make this value true if 'ArgumentError: undefined class/module' issues with Rails.cache.fetch arise in development
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  #
  # Use "letter_opener" to see test messages in the browser
  config.action_mailer.delivery_method = :letter_opener
  # Or, use mailgun to actually send email...be careful
  #config.action_mailer.delivery_method = :mailgun
  #config.action_mailer.mailgun_settings = {
  #  api_key: ENV['MAILGUN_API_KEY'],
  #  domain: ENV['MAILGUN_DOMAIN']
  #}

  config.i18n.fallbacks = [:en]

  # Set CLOUD_9_DEV_HOST to the preview URL host for your Cloud 9 environment
  config.action_mailer.default_url_options = { :host => ENV['CLOUD_9_DEV_HOST'], protocol: "https" }

  # 2022-08-03 AA
  # Set the value below to 'true' if you're getting errors in development about
  # assets missing from the asset pipeline. Specifically, there were some old
  # homepage videos for BSS, dbx and Lexicon in app/assets/images/development.
  # If you don't have them on your dev machine, you'll see an error when
  # trying to load those brands' homepage.
  #config.assets.unknown_asset_fallback = true # As of rails 5.1 defaults to false

  # Use middleware to show code coverage report
  config.middleware.use Rack::Static, :urls => ['/coverage'], :root => Rails.root.to_s, :index => 'index.html'
end
