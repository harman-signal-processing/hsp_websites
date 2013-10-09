ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails"
require "minitest/rails/capybara"
require "active_support/testing/setup_and_teardown"
require "database_cleaner"
require "mocha/setup"

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

  # Add more helper methods to be used by all tests here...
  teardown do
    DatabaseCleaner.clean 
  end
end

class ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers
  include Capybara::RSpecMatchers
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
    ActionMailer::Base.deliveries = []
  end

  def setup_toolkit_brands
    @digitech = FactoryGirl.create(:digitech_brand)
    @digitech_site = FactoryGirl.create(:website_with_products, folder: "digitech", brand: @digitech)
    @lexicon  = FactoryGirl.create(:lexicon_brand)
    @lexicon_site = FactoryGirl.create(:website_with_products, folder: "lexicon", brand: @lexicon)
    @bss = FactoryGirl.create(:bss_brand)
    # @bss_site = FactoryGirl.create(:website_with_products, folder: "bss", brand: @bss)
    @dbx = FactoryGirl.create(:dbx_brand)
    @dbx_site = FactoryGirl.create(:website_with_products, folder: "dbx", brand: @dbx)
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def admin_login_with(user, password, website)
    user.confirm!
    visit new_user_session_url(host: website.url, locale: I18n.default_locale)
    fill_in('user[email]', with: user.email)
    fill_in('user[password]', with: password)
    click_button 'Sign in'
  end

  def setup_and_login_queue_user
    @password = "pass123"
    @user = FactoryGirl.create(:user, 
      marketing_staff: true, 
      name: "Johnny Danger",
      password: @password, 
      password_confirmation: @password)
    @user.confirm!
    visit new_marketing_queue_user_session_url(host: @host)
    fill_in :marketing_queue_user_email, with: @user.email
    fill_in :marketing_queue_user_password, with: @password
    click_on "Sign in"
  end

  def setup_and_login_queue_admin
    @password = "pass123"
    @user = FactoryGirl.create(:user, 
      marketing_staff: true, 
      name: "Jason Kunz",
      queue_admin: true,
      password: @password, 
      password_confirmation: @password)
    @user.confirm!
    visit new_marketing_queue_user_session_url(host: @host)
    fill_in :marketing_queue_user_email, with: @user.email
    fill_in :marketing_queue_user_password, with: @password
    click_on "Sign in"
  end

  def setup_and_login_market_manager
    @password = "pass123"
    @user = FactoryGirl.create(:user, 
      marketing_staff: true, 
      name: "G. Scott",
      market_manager: true,
      password: @password, 
      password_confirmation: @password)
    @user.confirm!
    visit new_marketing_queue_user_session_url(host: @host)
    fill_in :marketing_queue_user_email, with: @user.email
    fill_in :marketing_queue_user_password, with: @password
    click_on "Sign in"
  end

end

# Turn.config.format = :outline
# Turn.config.natural = true