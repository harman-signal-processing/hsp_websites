ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"
require "active_support/testing/setup_and_teardown"
require "database_cleaner"
require "mocha/setup"
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

# Add `gem "minitest/rails/capybara"` to the test group of your Gemfile


# Uncomment if you want awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  # fixtures :all
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
    visit new_user_session_url(host: website.url, locale: I18n.default_locale)
    fill_in('user[email]', with: user.email)
    fill_in('user[password]', with: password)
    click_button 'Sign in'
  end
end

Turn.config.format = :outline
Turn.config.natural = true