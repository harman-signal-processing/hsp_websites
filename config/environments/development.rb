HarmanSignalProcessingWebsite::Application.configure do

  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  # config.cache_store = :dalli_store, "127.0.0.1", { namespace: "HSPDEV", expires_in: 1.day, compress: true }
  
  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  
  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  
  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict
  
  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5
  
  # Do not compress assets
  config.assets.compress = false
  
  # Expands the lines which load the assets
  config.assets.debug = false
  # config.assets.compile = true

  # config.action_controller.asset_host = "http://cdn.harmanpro.com"

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  
  config.i18n.fallbacks = true

  config.employee_invitation_code = "EMPLOYEE_INVITATION_CODE"
  config.rso_invitation_code = "RSO_INVITATION_CODE"
  config.media_invitation_code = "MEDIA_INVITATION_CODE"
  config.toolkit_url = "toolkit.lvh.me:3000"
  config.queue_url   = "queue.lvh.me:3000"

end

