require "rails_helper"

feature "Toolkit layout" do

  before do
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url
    Capybara.default_host = "http://#{@host}"
    Capybara.app_host = "http://#{@host}"
  end

  scenario "is used for toolkit URLs" do
    visit root_path

    expect(page).to have_content "Marketing Toolkit"
  end

  scenario "is used for devise URLs" do
    visit new_user_registration_path

    expect(page).to have_content "Marketing Toolkit"
  end
end
