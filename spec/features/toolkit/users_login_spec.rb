require "rails_helper"

feature "Toolkit users login" do

  before :all do
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url
    Capybara.default_host = "http://#{@host}"
    Capybara.app_host = "http://#{@host}"
  end

  before :each do
    allow_any_instance_of(Dealer).to receive(:geocode_address).and_return(true)

    @dealer = FactoryGirl.create(:dealer)
    @password = "pass123"
    @user = FactoryGirl.create(:user,
      dealer: true,
      account_number: @dealer.account_number,
      password: @password,
      password_confirmation: @password)
    @user.confirm

    visit new_toolkit_user_session_url(host: @host)
    fill_in :toolkit_user_email, with: @user.email
    fill_in :toolkit_user_password, with: @password
    click_on "Sign in"
  end

  it "should login" do
    expect(page).to have_content "Signed in successfully"
  end

  it "wont show login link after logging in" do
    expect(page).not_to have_link "Login"
    expect(page).not_to have_link "Sign up"
  end

  it "will have a link to manage account" do
    expect(page).to have_link "My account"
  end

  it "will have a functional logout link" do
    click_on "Logout"
    expect(page).to have_link "Login"
  end

end

