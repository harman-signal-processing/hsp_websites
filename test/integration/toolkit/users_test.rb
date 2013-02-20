require "minitest_helper"

describe "Toolkit Users Integration Test" do

  before do
    DatabaseCleaner.start
    setup_toolkit_brands
    @host = "test.toolkit.lvh.me"
    host! @host
    Capybara.default_host = "http://#{@host}" 
    Capybara.app_host = "http://#{@host}" 
  end
  
  describe "Valid Signup" do 
  	before do 
  		@dealer = FactoryGirl.create(:dealer)
  		visit new_toolkit_user_registration_url(host: @host)
  	end

  	it "should require account number" do 
  		within('#new_toolkit_user') do
	  		must_have_content "Harman Account Number"
	  		click_on "Sign up"
	  	end
  		page.must_have_content "email address on file.can't be blank"
  	end

  	it "should create a new unconfirmed user" do
  		user = FactoryGirl.build(:user)
  		within('#new_toolkit_user') do
  			fill_in_new_user_form(user, @dealer)
  			click_on "Sign up"
  		end
  		u = User.last
  		u.confirmed?.must_equal(false)
  	end  		

  	it "should associate the user with the dealer by account number" do 
  		user = FactoryGirl.build(:user)
  		within('#new_toolkit_user') do
  			fill_in_new_user_form(user, @dealer)
  			click_on "Sign up"
  		end
  		u = User.last
  		u.dealers.must_include(@dealer)
  	end

  	it "should send the confirmation email to the dealer not the user" do
  		user = FactoryGirl.build(:user)
  		within('#new_toolkit_user') do
  			fill_in_new_user_form(user, @dealer)
  			click_on "Sign up"
  		end
  		last_email.subject.must_have_content "Harman Toolkit Confirmation instructions"
  		last_email.to.must_include(@dealer.email)
  		last_email.body.must_have_content user.name
  		last_email.body.must_have_content user.email
  	end  		
  end

  describe "Invalid Signup" do
  	before do
  		visit new_toolkit_user_registration_url(host: @host)
  	end

  	it "should send an email error to user where no dealer is found" do 
  		user = FactoryGirl.build(:user)
  		dealer = FactoryGirl.build(:dealer) # un-saved, so should error when looking up
  		within('#new_toolkit_user') do
  			fill_in_new_user_form(user, dealer)
  			click_on "Sign up"
  		end
  		last_email.subject.must_have_content "can't confirm account"
  		last_email.to.must_include(user.email)
  		last_email.cc.must_include TOOLKIT_ADMINISTRATOR_EMAIL_ADDRESSES.first
  		last_email.body.must_have_content TOOLKIT_ADMINISTRATORS_CONTACT_INFO.first
  	end
  end

  describe "Confirmation" do 
  	it "should confirm the new user" do
  		@dealer = FactoryGirl.create(:dealer)
  		@user = FactoryGirl.create(:user, dealer: true, account_number: @dealer.account_number)
  		@user.confirmed?.must_equal(false)
  		visit toolkit_user_confirmation_url(@user, :confirmation_token => @user.confirmation_token, host: @host)
  		@user.reload
  		@user.confirmed?.must_equal(true)
  	end
  end

  describe "Login" do
  	before do
  		@dealer = FactoryGirl.create(:dealer)
  		@password = "pass123"
  		@user = FactoryGirl.create(:user, 
  			dealer: true, 
  			account_number: @dealer.account_number, 
  			password: @password, 
  			password_confirmation: @password)
  		@user.confirm!
  		visit new_toolkit_user_session_url(host: @host)
  		fill_in :toolkit_user_email, with: @user.email
  		fill_in :toolkit_user_password, with: @password
  		click_on "Sign in"
  	end

  	it "should login" do 
  		must_have_content "Signed in successfully"
  	end

  	it "wont show login link after logging in" do
  		wont_have_link "Login"
  		wont_have_link "Sign up"
  	end

  	it "will have a link to manage account" do
  		must_have_link "My account"
  	end

  	it "will have a logout link" do
  		must_have_link "Logout"
  		click_on "Logout"
  		must_have_link "Login"
  	end		
  end

	def fill_in_new_user_form(user, dealer)
		fill_in :toolkit_user_name, with: user.name
		fill_in :toolkit_user_email, with: user.email
		fill_in :toolkit_user_account_number, with: dealer.account_number
		fill_in :toolkit_user_password, with: "pass123"
		fill_in :toolkit_user_password_confirmation, with: "pass123"  		
	end

end