require "rails_helper"

feature "Software activation" do

  before :all do
    @website = FactoryGirl.create(:website)
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
  end

  scenario "software activation returns correct activation code" do
    @software = FactoryGirl.create(:software_for_activation)
    challenge = "1234-5678-90AB"

    visit software_activation_path(@software.activation_name, challenge, locale: I18n.default_locale)

    expect(page).to have_content "383ED7C0-FCAC80F8-A403F8DB"
  end

end
