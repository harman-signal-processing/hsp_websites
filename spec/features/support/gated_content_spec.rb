require "rails_helper"

feature "Gated support content" do

  before :all do
    @website = FactoryBot.create(:website)
    @brand = @website.brand
    Capybara.default_host = "http://#{@website.url}"
    Capybara.app_host = "http://#{@website.url}"
    @user = FactoryBot.build(:user)
  end

  after :all do
    DatabaseCleaner.clean_with(:deletion)
  end

  scenario "Visiting without logging in should redirect to login page" do
    visit gated_support_path

    expect(current_path).to eq(new_user_session_path)
  end

  scenario "Signup without invitation code" do
    count = User.count
    visit gated_support_path
    click_on "register"
    fill_in 'Name', with: @user.name
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "Pass123"
    fill_in 'Password confirmation', with: "Pass123"
    click_button "Sign up"

    expect(User.count).to eq(count)
    expect(page).to have_content "it is cAsE sEnSiTiVe."
  end

  scenario "Signup with an invitation code" do
    count = User.count
    visit gated_support_path
    click_on "register"
    fill_in 'Name', with: @user.name
    fill_in 'Email', with: @user.email
    fill_in 'Invitation code', with: ENV['TECHNICIAN_INVITATION_CODE']
    fill_in 'Password', with: "Pass123"
    fill_in 'Password confirmation', with: "Pass123"
    click_button "Sign up"

    user = User.last
    expect(User.count).to eq(count + 1)
    expect(user.technician?).to be(true)
    expect(user.market_manager?).to be(false)
    expect(user.admin?).to be(false)

    expect(page.current_path).to eq(gated_support_path)
  end

end

