Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.args << '--headless'
    opts.args << '--disable-gpu' if Gem.win_platform?
    opts.args << '--disable-site-isolation-trials'
  end
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

Capybara.match = :prefer_exact
Capybara.server = :webrick
Capybara.javascript_driver = :headless_chrome # use this one to keep the js testing in the background
#Capybara.javascript_driver = :chrome # use this one if you want to see the tests running in the browser
Capybara.server_port = 63427 # set here so it can be whitelisted in Adyen
Capybara.always_include_port = true

# Javascript testing note...
#
# In order for JS testing to work, you must have run locally (and fairly recently):
#
#   bin/rails assets:precompile
#
# If changes have been made to the javascript code, then re-run the precompile
# task again so changes are updated into the compiled javascript file.
#
# The alternative is to allow the test environment to compile assets on
# the fly. We have this disabled in config/environments/test.rb so that the bulk
# of the tests run faster.
