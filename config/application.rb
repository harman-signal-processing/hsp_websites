require_relative 'boot'

require "active_job/railtie"
require "active_record/railtie"
#require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
#require "action_mailbox/engine"
#require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

ActiveSupport::Deprecation.debug = true if Rails.env.development?

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HarmanSignalProcessingWebsite
  class Application < Rails::Application
    config.load_defaults 7.0
    config.active_support.cache_format_version = 6.1 # Remove AFTER successful deployment with rails 7

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #
    #============================================
    # All the below came from the rails 4.2.8 app
    #============================================
    #
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Mountain Time (US & Canada)'
    I18n.enforce_available_locales = false
    config.i18n.fallbacks = [I18n.default_locale]

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Enable the asset pipeline
    config.assets.enabled = true

    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(application)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.generators do |g|
        g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.active_job.queue_adapter = :delayed_job

    # Override these in environment configs...
    config.default_site_name        = "Harman Professional Brand"
    config.action_mailer.default_url_options = { :host => "pro.harman.com", protocol: "https" }

    config.document_types = [
      ["Owner's Manual", "owners_manual"],
      ["Cut Sheet", "cut_sheet"],
      ["Quickstart Guide", "quickstart_guide"],
      ["Quick Reference Guide", "quick_reference_guide"],
      ["VoIP Reference Guide", "voip_reference_guide"],
      ["Application Guide", "application_guide"],
      ["Install Guide", "install_guide"],
      ["Preset List", "preset_list"],
      ["Schematic", "schematic"],
      ["Service Manual", "service_manual"],
      ["Spec Sheet", "spec_sheet"],
      ["Parts List", "parts_list"],
      ["Calibration Procedure", "calibration_procedure"],
      ["CAD Files", "cad_files"],
      ["CAD Drawing front", "cad_drawing_front"],
      ["CAD Drawing rear", "cad_drawing_rear"],
      ["Brochure", "brochure"],
      ["Safety & Compliance", "safety_sheet"],
      ["Other", "other"]
    ]

    config.document_languages = (LanguageList::COMMON_LANGUAGES.map{|l| [l.name, l.iso_639_1]} + [["Australia", "au"]]).sort_by { |lang| lang[0] }

  end
end
