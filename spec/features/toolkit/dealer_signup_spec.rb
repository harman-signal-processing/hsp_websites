require "rails_helper"

feature "Dealer signs up for Toolkit" do

  before :each do
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url
    Capybara.default_host = "http://#{@host}"
    Capybara.app_host = "http://#{@host}"

    allow_any_instance_of(Dealer).to receive(:geocode_address).and_return(true)
    @dealer = FactoryGirl.create(:dealer)
    visit root_url(host: @host)
    within('.top-bar') do
      click_on "Sign up"
    end
    choose :signup_type_dealer
    click_on "Continue"
  end

  scenario "should require account number" do
    within('#new_toolkit_user') do
      expect(page).to have_content("Harman Pro Account Number")
      click_on "Sign up"
    end

    expect(page).to have_content "email address on file.can't be blank"
  end

  scenario "should create a new unconfirmed user, belonging to matching dealer" do
    user = FactoryGirl.build(:user, email: "someone@dealer.com")

    fill_in_new_dealer_user_form(user, @dealer)

    u = User.last
    expect(u.confirmed?).to be(false)
    expect(u.dealers).to include(@dealer)
  end

  scenario "should send email to dealer, not user" do
    user = FactoryGirl.build(:user, email: "someone@dealer.com")

    fill_in_new_dealer_user_form(user, @dealer)

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to match "Harman Toolkit Confirmation instructions"
    expect(last_email.to).to include(@dealer.email)
    expect(last_email.body).to have_content user.name
    expect(last_email.body).to have_content user.email
  end

  scenario "should send an email error to user where no dealer is found" do
    user = FactoryGirl.build(:user, email: "someone@dealer.com")
    dealer = FactoryGirl.build(:dealer) # un-saved, so should error when looking up

    fill_in_new_dealer_user_form(user, dealer)

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to match "can't confirm account"
    expect(last_email.to).to include(user.email)
    expect(last_email.cc).to include HarmanSignalProcessingWebsite::Application.config.toolkit_admin_email_addresses.first
    expect(last_email.body).to have_content HarmanSignalProcessingWebsite::Application.config.toolkit_admin_contact_info.first
  end

  def fill_in_new_dealer_user_form(user, dealer)
    within('#new_toolkit_user') do
      fill_in :toolkit_user_name, with: user.name
      fill_in :toolkit_user_email, with: user.email
      fill_in :toolkit_user_account_number, with: dealer.account_number
      fill_in :toolkit_user_password, with: "pass123"
      fill_in :toolkit_user_password_confirmation, with: "pass123"
      click_on "Sign up"
    end
  end
end
