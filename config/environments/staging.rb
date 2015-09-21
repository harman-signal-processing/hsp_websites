HarmanSignalProcessingWebsite::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Compress JavaScripts and CSS.
  #config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Add fonts to asset pipeline
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  config.assets.precompile += %w( .svg .eot .woff .ttf )

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( *.jpg *.png *.gif
    lightbox/*
    vendor/custom.modernizr.js
    hiqnet.css
    hiqnet.js
    performancemanager.css
    performancemanager.js
    introducing_epedal.css
    introducing_stompbox.css
    istomp.css
    admin.js
    admin.css
    archimedia.css
    audio-architect.css
    bss.js
    bss.css
    crown.css
    crown.js
    soundcraft.css
    soundcraft.js
    dbx.css
    dbx.js
    digitech.css
    digitech.js
    dod.css
    dod.js
    jbl_commercial.css
    jbl_commercial.js
    lexicon.css
    lexicon.js
    idx.css
    site.css
    toolkit.css
    toolkit_application.js
    marketing_queue.css
    marketing_queue_application.js
    teaser_application.js
    dod_teaser.css
    studer.css
    studer.js
    akg.css
    akg.js
    jbl_professional.css
    jbl_professional.js
    )

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug
  config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  config.cache_store = :dalli_store, "127.0.0.1", { namespace: "HSPSTAGING", expires_in: 1.day, compress: true }

  # Enable serving of images, stylesheets, and javascripts from an asset server
  config.action_controller.asset_host = ENV['ASSET_HOST']

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  #config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5


  config.action_mailer.default_url_options = { :host => 'www.digitech.com' }

  config.employee_invitation_code = "GROOVY"
  config.rso_invitation_code = "HSP-RSO"
  config.auto_translate      = false # probably set to false after completing test of this new system
end
