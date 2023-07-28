require "rails_helper"

feature "Not Geofenced", :devise do

  before :all do
    @website = FactoryBot.create(:website)
    FactoryBot.create(:website_locale, website: @website, locale: "en-asia")
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryBot.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
  end

  before :each do
    admin_login_with(@user.email, "password", @website)
    # Fake IP address is in the US
    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip) { '172.69.42.159' }
  end

  describe "admin visits en-asia" do
    it "should not redirect" do
      visit root_path(locale: "en-asia")

      expect(page.current_path).to eq("/en-asia")
    end
  end

end