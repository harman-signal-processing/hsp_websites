require 'rb-inotify' if RUBY_PLATFORM.downcase.include?("linux")
require 'rb-fsevent' if RUBY_PLATFORM.downcase.include?("darwin") # Mac OS

# Disabled Rack::Attack for testing because we throw a lot of requests at
# the app really fast which looks like an attack but isn't.
Rack::Attack.enabled = false

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = :none

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { :host => "test.harman.lvh.me", protocol: "http" }

end

# Make our tests fast by avoiding asset compilation
# but do not raise when assets are not compiled either
# Borrowed from:
# https://grosser.it/2017/04/29/rails-5-1-do-not-compile-asset-in-test-vs-asset-is-not-present-in-the-asset-pipeline/
Rails.application.config.assets.compile = false
Sprockets::Rails::Helper.prepend(Module.new do
  def resolve_asset_path(path, *)
    super || path
  end
end)
