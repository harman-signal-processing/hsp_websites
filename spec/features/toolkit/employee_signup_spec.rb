require "rails_helper"

feature "Employee signs up for Toolkit" do

  before :all do
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url
    Capybara.default_host = "http://#{@host}"
    Capybara.app_host = "http://#{@host}"
  end

  before :each do
    visit root_url(host: @host)
    within('.top-bar') do
      click_on "Sign up"
    end
    choose :signup_type_employee
    click_on "Continue"
  end

  scenario "should NOT require account number" do
    within('#new_toolkit_user') do
      expect(page).not_to have_content "Harman Pro Account Number"
    end
  end

  scenario "should require invitation code" do
    within('#new_toolkit_user') do
      expect(page).to have_content "Invitation code"
      fill_in :toolkit_user_invitation_code, with: "something wrong"
      click_on "Sign up"
    end

    expect(page).to have_content "it is cAsE sEnSiTiVe."
  end

  scenario "should create a new unconfirmed user" do
    user = FactoryBot.build(:user)

    fill_in_new_employee_user_form(user)

    u = User.last
    expect(u.confirmed?).to be(false)
  end

  scenario "should send the confirmation email to the new user" do
    user = FactoryBot.build(:user)

    fill_in_new_employee_user_form(user)

    last_email = ActionMailer::Base.deliveries.last
    expect(last_email.subject).to match "HARMAN Toolkit Confirmation link"
    expect(last_email.to).to include(user.email)
    expect(last_email.body).to have_content user.name
    expect(last_email.body).to have_content user.email
  end

  def fill_in_new_employee_user_form(user)
    within('#new_toolkit_user') do
      fill_in :toolkit_user_name, with: user.name
      fill_in :toolkit_user_email, with: user.email
      fill_in :toolkit_user_invitation_code, with: HarmanSignalProcessingWebsite::Application.config.employee_invitation_code
      fill_in :toolkit_user_password, with: "pass123"
      fill_in :toolkit_user_password_confirmation, with: "pass123"
      click_on "Sign up"
    end
  end

end
