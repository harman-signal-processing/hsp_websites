require 'rails_helper'

feature "Browse Videos" do

  before :all do
    @website = create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  # We used to create a fancy videos pages based on the brand's channel
  # on youtube but then they got all uppity about capitalization throughout
  # Harman sites that we don't control and canceled our API access. Neat.
  describe "videos index" do
    it "should show an error" do
      visit videos_path
      expect(page).to have_text("Error")
    end
  end

end
