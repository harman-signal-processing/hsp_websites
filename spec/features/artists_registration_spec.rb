require "rails_helper"

feature "Artists registration" do

  before :all do
    @website = FactoryBot.create(:website, folder: "digitech")
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"

    @affiliate_tier = FactoryBot.create(:affiliate_tier)
    @top_tier = FactoryBot.create(:top_tier)
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  scenario "Signup without invitation will be an affiliate" do
    count = Artist.count
    visit new_artist_registration_path

    fill_in 'artist_name', with: "Joe Schmoe"
    fill_in 'artist_email', with: "joe@schmoe.com"
    fill_in 'artist_password', with: "Pass123"
    fill_in 'artist_password_confirmation', with: "Pass123"
    click_button "Sign up"

    expect(current_path).to match(become_an_artist_path)
    expect(page).to have_content "A message with a confirmation link has been sent to your email address. Please open the link to activate your account."
    expect(Artist.count).to eq(count + 1)
    new_artist = Artist.last
    expect(new_artist.approver_id).to eq(nil)
    expect(new_artist.artist_tier).to eq(@affiliate_tier)
  end

  scenario "Signup with an invitation code will be that tier" do
    visit new_artist_registration_path

    fill_in 'artist_name', with: "Robert Smith"
    fill_in 'artist_email', with: "robert.smith@thecure.com"
    fill_in 'artist_password', with: "elise"
    fill_in 'artist_password_confirmation', with: "elise"
    fill_in 'artist_invitation_code', with: @top_tier.invitation_code
    click_button "Sign up"

    new_artist = Artist.last
    expect(new_artist.artist_tier).to eq(@top_tier)
  end
end
