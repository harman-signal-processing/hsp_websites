require "rails_helper"

# This set of specs uses static IP addresses which at the time of writing belonged
# to the indicated countries. If that changes, the IP addresses will need to be
# updated. Alternatively stub the call to Country or even clean_country_code
# But I couldn't get that to work.
#
# Also, in order to spec the respose for a given locale, it needs to be added
# to ALL_LOCALES in the i18n initializer. The routes.rb file creates routes
# based on those locales in the test environment.

feature "Bots not Geofenced" do
  before :all do
    @website = FactoryBot.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"

    # See config/initializers/i18n.rb for ALL_LOCALES
    ALL_LOCALES.each{|locale| create(:website_locale, website: @website, locale: locale)}
  end

  before :each do
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  describe "US-based crawler" do
    before :each do
      # Fake IP address is in the US
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '172.69.42.159' }
      page.driver.header('User-Agent', 'Googlebot/2.1 (+http://www.google.com/bot.html)')
    end

    it "tries to visit en-asia should NOT redirect to en-US" do
      visit "/en-asia"

      expect(page.current_path).to eq("/en-asia")
    end

    it "tries to visit en should NOT redirect to en-US" do
      visit "/en"

      expect(page.current_path).to eq("/en")
    end

    it "visits homepage with no locale in URL redirect to geo-based locale" do
      visit "/"

      expect(page.current_path).to eq("/en-US")
    end
  end

end
