require File.expand_path('../boot', __FILE__)
#require File.expand_path('lib/custom_domain_cookie.rb') # see below...
require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end

module HarmanSignalProcessingWebsite
  class Application < Rails::Application

    # Trying to re-write fixes with bad URL params like this:
    # /en-US/videos/play/TeZN3dGmT10%20?iframe=true&width=100%&height=100%
    # config.middleware.insert_before(Rack::Lock, Rack::Rewrite) do
    #   r301   %r{/([\w\/\-]*)(\%20)?\?iframe.*},  '/$1'
    # end

    # This was a good idea to use different domains in cookies depending on
    # the site being called, but it broke stuff...maybe with the upgrade to rails 3.2.1
    # config.middleware.use CustomDomainCookie, "digitech.com"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'
    I18n.enforce_available_locales = false

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(application)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Trying to encourage asset pipeline to precompile the images in the vendor/assets folders
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)

    config.generators do |g|
        g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    config.active_job.queue_adapter = :delayed_job

    config.active_record.raise_in_transactional_callbacks = true

    # Override these in environment configs...
    config.employee_invitation_code = ENV['EMPLOYEE_INVITATION_CODE']
    config.rso_invitation_code      = ENV['RSO_INVITATION_CODE']
    config.media_invitation_code    = ENV['MEDIA_INVITATION_CODE']
    config.toolkit_url              = "marketingtoolkit.harmanpro.com"
    config.queue_url                = "marketingqueue.harmanpro.com"
    config.default_site_name        = "Harman Signal Processing"
    config.toolkit_admin_email_addresses = ENV['TOOLKIT_ADMIN_EMAIL_ADDRESSES'].split("|")
    config.toolkit_admin_contact_info    = ENV['TOOLKIT_ADMIN_CONTACT_INFO'].split("|")

    config.document_types = [
      ["Owner's Manual", "owners_manual"],
      ["Cut Sheet", "cut_sheet"],
      ["Quickstart Guide", "quickstart_guide"],
      ["Quick Reference Guide", "quick_reference_guide"],
      ["Application Guide", "application_guide"],
      ["Install Guide", "install_guide"],
      ["Preset List", "preset_list"],
      ["Schematic", "schematic"],
      ["Service Manual", "service_manual"],
      ["Parts List", "parts_list"],
      ["Calibration Procedure", "calibration_procedure"],
      ["CAD Files", "cad_files"],
      ["CAD Drawing front", "cad_drawing_front"],
      ["CAD Drawing rear", "cad_drawing_rear"],
      ["Brochure", "brochure"],
      ["Safety Sheet", "safety_sheet"],
      ["Other", "other"]
    ]

    config.document_languages = [
      ["English", "en"],
      ["Chinese", "zh"],
      ["Spanish", "es"],
      ["French", "fr"],
      ["German", "de"]
    ]

    config.bing_translator_id  = ENV['BING_TRANSLATOR_ID']
    config.bing_translator_key = ENV['BING_TRANSLATOR_KEY']
    config.auto_translate      = false # override in environment configs as needed

    config.hpro_execs = ENV['TOOLKIT_ADMIN_EMAIL_ADDRESSES'].split("|")
  end
end
