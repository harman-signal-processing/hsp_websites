require "rails_helper"

feature "Distributor signs up for Toolkit" do

  before :all do
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url
    Capybara.default_host = "http://#{@host}"
    Capybara.app_host = "http://#{@host}"
  end

  before :each do
    @distributor = FactoryGirl.create(:distributor)
    visit root_url(host: @host)
    within('.top-bar') do
      click_on "Sign up"
    end
    choose :signup_type_distributor
    click_on "Continue"
  end

  scenario "should require account number" do
    within('#new_toolkit_user') do
      expect(page).to have_content("Harman Pro Account Number")
      click_on "Sign up"
    end

    expect(page).to have_content "email address on file.can't be blank"
  end

  scenario "should create a new unconfirmed user, belonging to matching distributor" do
    user = FactoryGirl.build(:user, email: "someone@distributor.com")

    fill_in_new_distributor_user_form(user, @distributor)

    u = User.last
    expect(u.confirmed?).to be(false)
    expect(u.distributors).to include(@distributor)
  end

  scenario "should send the confirmation email to the distributor and the user" do
    user = FactoryGirl.build(:user, email: "someone@distributor.com")

    fill_in_new_distributor_user_form(user, @distributor)

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to match "Harman Toolkit Confirmation instructions"
    expect(last_email.to).to include(@distributor.email)
    expect(last_email.to).to include(user.email)
    expect(last_email.body).to have_content user.name
    expect(last_email.body).to have_content user.email
  end

  scenario "should NOT send an email error to user where no distributor is found" do
    user = FactoryGirl.build(:user, email: "someone@distributor.com")
    distributor = FactoryGirl.build(:distributor) # un-saved, so should error when looking up

    fill_in_new_distributor_user_form(user, distributor)

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to match "Harman Toolkit Confirmation instructions"
    expect(last_email.to).to include(user.email)
    expect(last_email.body).to have_content user.name
    expect(last_email.body).to have_content user.email
  end

  scenario "should store the account number with the user record" do
    user = FactoryGirl.build(:user, email: "someone@dealer.com")

    fill_in_new_distributor_user_form(user, @distributor)

    expect(User.last.account_number).to eq(@distributor.account_number)
  end

  def fill_in_new_distributor_user_form(user, distributor)
    within('#new_toolkit_user') do
      fill_in :toolkit_user_name, with: user.name
      fill_in :toolkit_user_email, with: user.email
      fill_in :toolkit_user_account_number, with: distributor.account_number
      fill_in :toolkit_user_password, with: "pass123"
      fill_in :toolkit_user_password_confirmation, with: "pass123"
      click_on "Sign up"
    end
  end

end
