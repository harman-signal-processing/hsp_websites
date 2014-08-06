ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require "minitest/rails/capybara"
require "active_support/testing/setup_and_teardown"
require "database_cleaner"
require "mocha/setup"
require "support/common_test_methods"

MiniTest::Unit::TestCase.send(:include, FactoryGirl::Syntax::Methods)
DatabaseCleaner.strategy = :transaction # (transaction doesn't work with webkit/javascript)

Capybara.configure do |config|
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
  config.javascript_driver = :webkit
end

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  # fixtures :all

  setup do
    DatabaseCleaner.start 
    Brand.destroy_all
  end

  # Add more helper methods to be used by all tests here...
  teardown do
    DatabaseCleaner.clean 
  end
end

class ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  include Capybara::Assertions
  include CommonTestMethods

  [ApplicationController, ActionController::Base].each do |klass|
    klass.class_eval do
      def default_url_options(options = {})
        { :locale => I18n.default_locale }.merge(options)
      end
    end
  end

  setup do
    DatabaseCleaner.start 
    Brand.destroy_all
  end

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    # Capybara.default_driver = :webkit
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
    ActionMailer::Base.deliveries = []
  end

end

# Turn.config.format = :outline
# Turn.config.natural = true