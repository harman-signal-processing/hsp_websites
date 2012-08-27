ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require "minitest/autorun"
require "minitest/rails"
require "capybara/rails"
require "active_support/testing/setup_and_teardown"
require "database_cleaner"
require "mocha"
# require "selenium-webdriver"

MiniTest::Unit::TestCase.send(:include, FactoryGirl::Syntax::Methods)
DatabaseCleaner.strategy = :transaction # (transaction doesn't work with webkit/javascript)
# DatabaseCleaner.strategy = :truncation
# DatabaseCleaner.strategy = :deletion # seems faster than truncation for me

# Capybara.register_driver :selenium do |app|
#   profile = Selenium::WebDriver::Firefox::Profile.new
#   profile["network.proxy.type"] = 0 # skip proxy
#   # profile["network.proxy.http"] = "http://example.com"
#   # profile["network.proxy.http_port"] = 80
#   Capybara::Selenium::Driver.new(app, profile: profile)
# end
# Capybara.javascript_driver = :selenium
Capybara.javascript_driver = :webkit
# Capybara.automatic_reload = false

class MiniTest::Rails::Spec
  # Add methods to be used by all specs here
end

class MiniTest::Rails::Model
  # Add methods to be used by model specs here
  teardown do
    DatabaseCleaner.clean       # Truncate the database
  end
end

class MiniTest::Rails::Controller
  # Add methods to be used by controller specs here
  teardown do
    DatabaseCleaner.clean       # Truncate the database
  end
end

class MiniTest::Rails::Helper
  # Add methods to be used by helper specs here
  teardown do
    DatabaseCleaner.clean       # Truncate the database
  end
end

class MiniTest::Rails::Mailer
  # Add methods to be used by mailer specs here
  teardown do
    DatabaseCleaner.clean       # Truncate the database
  end
end

# If you want to test other locales in the future, you'll need to
# add all the possibilities for the test env in the class method
#
# WebsiteLocale.all_unique_locales
#
class MiniTest::Rails::Integration
  # Add methods to be used by integration specs here
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  [ApplicationController, ActionController::Base].each do |klass|
    klass.class_eval do
      def default_url_options(options = {})
        { :locale => I18n.default_locale }.merge(options)
      end
    end
  end

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    # Capybara.default_driver = :webkit
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end

end

Turn.config.format = :outline
Turn.config.natural = true