require "rails_helper"

feature "Admin software", :devise do

  before :all do
    @website = FactoryBot.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryBot.create(:user, market_manager: true, password: "password", confirmed_at: 1.minute.ago)
  end

  describe "uploading new software", :js do
    scenario "successfully" do
      skip "Someday it would be nice to make this work, but testing javascript with selenium is a headache"
      admin_login_with(@user.email, "password", @website)
      click_on "Software Downloads"
      click_on "New software"

      attach_file("file", File.absolute_path(Rails.root.join("spec/fixtures/test.jpg")))
      fill_in "Name", with: "Cool software"
      fill_in "Version", with: "1.0.1"
      check 'Software is active.'

      click_on "Create Software"

      expect(page).to have_link("test.jpg")
    end
  end
end

