require 'rails_helper'

feature "Browse Events" do

  before :all do
    @website = create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  describe "events index with upcoming events" do
    let!(:events) { create_list(:event, 2, brand: @website.brand, active: true) }
    it "shows event list" do
      visit events_path

      expect(page).to have_content events.first.name
    end
  end

  describe "events index with no upcoming events, but upcoming learning sessions" do
    it "redirects to learning sessions path" do
      expect(LearningSessionService).to receive(:get_learning_session_data).with(@website.brand.name.downcase).and_return({
      "page_content": {
        "id":1,
        "body":"Learning Session page content",
        "custom_css":"",
        "brand_id":@website.brand_id,
        "webinars_link":"https://foo.com"},
        "events":[],
        "featured_videos":[]
      }).at_least(:once)

      visit events_path

      expect(page.current_path).to eq(learning_sessions_path(locale: I18n.default_locale))
    end
  end

  describe "show event page" do
    let!(:event) { create(:event, brand: @website.brand, active: true) }
    it "should show the event" do
      visit event_path(event, locale: I18n.default_locale)

      expect(page).to have_content(event.name)
    end
  end

end


