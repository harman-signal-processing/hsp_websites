require "rails_helper"

# This set of specs uses static IP addresses which at the time of writing belonged
# to the indicated countries. If that changes, the IP addresses will need to be
# updated. Alternatively stub the call to Country or even clean_country_code
# But I couldn't get that to work.
#
# Also, in order to spec the respose for a given locale, it needs to be added
# to ALL_LOCALES in the i18n initializer. The routes.rb file creates routes
# based on those locales in the test environment.

feature "Geofencing" do

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

  describe "US visitor" do
    before :each do
      # Fake IP address is in the US
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '172.69.42.159' }
    end

    it "tries to visit en-asia should redirect to en-US" do
      visit root_path(locale: "en-asia")

      expect(page.current_path).to eq("/en-US")
    end

    it "tries to visit en should redirect to en-US" do
      visit root_path(locale: "en")

      expect(page.current_path).to eq("/en-US")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/en-US")
    end
  end

  describe "UK visitor" do
    before :each do
      # Fake IP address is in the UK
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '172.70.90.234' }
    end

    it "tries to visit en-asia should redirect to en" do
      visit root_path(locale: "en-asia")

      expect(page.current_path).to eq("/en")
    end

    it "tries to visit en-US should redirect to en" do
      visit root_path(locale: "en-US")

      expect(page.current_path).to eq("/en")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/en")
    end
  end

  describe "New Zealand visitor" do
    before :each do
      # Fake IP address is in New Zealand
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '125.236.198.17' }
    end

    it "tries to visit en should stay on en" do
      visit root_path(locale: "en")

      expect(page.current_path).to eq("/en")
    end

    it "tries to visit en-US should redirect to en" do
      visit root_path(locale: "en-US")

      expect(page.current_path).to eq("/en")
    end

    it "tries to visit en-asia should redirect to en" do
      visit root_path(locale: "en-asia")

      expect(page.current_path).to eq("/en")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/en")
    end
  end

  describe "APAC visitor" do
    before :each do
      # Fake IP address is in Singapore
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '34.101.81.171' }
    end

    # Originally, SHOULD redirect. Now should NOT--due to complaints.
    it "tries to visit en should NOT redirect to en-asia" do
      visit root_path(locale: "en")

      expect(page.current_path).not_to eq("/en-asia")
    end

    # Originally, SHOULD redirect. Now should NOT--due to complaints.
    it "tries to visit en-US should NOT redirect to en-asia" do
      visit root_path(locale: "en-US")

      expect(page.current_path).not_to eq("/en-asia")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/en-asia")
    end
  end

  describe "China visitor" do
    before :each do
      # Fake IP address is in China
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '124.223.30.144' }
    end

    # Originally, SHOULD redirect. Now should NOT--due to complaints.
    it "tries to visit en should NOT redirect to en-asia" do
      visit root_path(locale: "en")

      expect(page.current_path).not_to eq("/en-asia")
    end

    # Originally, SHOULD redirect. Now should NOT--due to complaints.
    it "tries to visit en-US should NOT redirect to en-asia" do
      visit root_path(locale: "en-US")

      expect(page.current_path).not_to eq("/en-asia")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/zh")
    end
  end

  describe "Hong Kong visitor" do
    before :each do
      # Fake IP address is in Hong Kong
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '18.167.234.221' }
    end

    # Originally, SHOULD redirect. Now should NOT--due to complaints.
    it "tries to visit en should NOT redirect to en-asia" do
      visit root_path(locale: "en")

      expect(page.current_path).not_to eq("/en-asia")
    end

    # Originally, SHOULD redirect. Now should NOT--due to complaints.
    it "tries to visit en-US should NOT redirect to en-asia" do
      visit root_path(locale: "en-US")

      expect(page.current_path).not_to eq("/en-asia")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/zh")
    end
  end

  describe "France visitor" do
    before :each do
      # Fake IP address is in France
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '104.121.31.255' }
    end

    it "tries to visit en-asia should redirect to en" do
      visit root_path(locale: "en-asia")

      expect(page.current_path).to eq("/en")
    end

    it "tries to visit en-US should redirect to en" do
      visit root_path(locale: "en-US")

      expect(page.current_path).to eq("/en")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/fr")
    end
  end

  describe "Visitor from a country not in our translations" do
    before :each do
      # Fake IP address is in Bahrain
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '15.184.48.78' }
    end

    it "tries to visit en-asia should redirect to en" do
      visit root_path(locale: "en-asia")

      expect(page.current_path).to eq("/en")
    end

    it "tries to visit en-US should redirect to en" do
      visit root_path(locale: "en-US")

      expect(page.current_path).to eq("/en")
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/en")
    end
  end

  describe "Visitor with unknown IP" do
    before :each do
      # Fake IP address is internal
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '127.0.0.1' }
    end

    it "visits homepage with no locale in URL" do
      visit ("/")

      expect(page.current_path).to eq("/en")
    end
  end
end
