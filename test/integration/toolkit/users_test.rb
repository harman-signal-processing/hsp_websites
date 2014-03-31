require "test_helper"

describe "Toolkit Users Integration Test" do

  before :each do
    DatabaseCleaner.start
    Brand.destroy_all
    setup_toolkit_brands
    @host = HarmanSignalProcessingWebsite::Application.config.toolkit_url 
    host! @host
    Capybara.default_host = "http://#{@host}" 
    Capybara.app_host = "http://#{@host}" 
    Dealer.any_instance.stubs(:geocode_address) # don't actually do geocoding here
  end

  after :each do
    DatabaseCleaner.clean
  end
  
  describe "Dealer Signup" do 
  	before do 
  		@dealer = FactoryGirl.create(:dealer)
      visit root_url(host: @host)
      within('.top-bar') do
        click_on "Sign up"
      end
      choose :signup_type_dealer
      click_on "Continue"
  	end

  	it "should require account number" do 
  		within('#new_toolkit_user') do
	  		page.must_have_content "Harman Pro Account Number"
	  		click_on "Sign up"
	  	end
  		page.must_have_content "email address on file.can't be blank"
  	end

  	it "should create a new unconfirmed user" do
  		user = FactoryGirl.build(:user)
  		within('#new_toolkit_user') do
  			fill_in_new_dealer_user_form(user, @dealer)
  			click_on "Sign up"
  		end
  		u = User.last
  		u.confirmed?.must_equal(false)
  	end  		

  	it "should associate the user with the dealer by account number" do 
  		user = FactoryGirl.build(:user)
  		within('#new_toolkit_user') do
  			fill_in_new_dealer_user_form(user, @dealer)
  			click_on "Sign up"
  		end
  		u = User.last
  		u.dealers.must_include(@dealer)
  	end

  	it "should send the confirmation email to the dealer not the user" do
  		user = FactoryGirl.build(:user)
  		within('#new_toolkit_user') do
  			fill_in_new_dealer_user_form(user, @dealer)
  			click_on "Sign up"
  		end
  		last_email.subject.must_match "Harman Toolkit Confirmation instructions"
  		last_email.to.must_include(@dealer.email)
  		last_email.body.must_include user.name
  		last_email.body.must_include user.email
  	end  		
  end

  describe "Invalid Dealer Signup" do
  	before do
  		visit root_url(host: @host)
      within('.top-bar') do
        click_on "Sign up"
      end
      choose :signup_type_dealer
      click_on "Continue"
  	end

  	it "should send an email error to user where no dealer is found" do 
  		user = FactoryGirl.build(:user)
  		dealer = FactoryGirl.build(:dealer) # un-saved, so should error when looking up
  		within('#new_toolkit_user') do
  			fill_in_new_dealer_user_form(user, dealer)
  			click_on "Sign up"
  		end
  		last_email.subject.must_match "can't confirm account"
  		last_email.to.must_include(user.email)
  		last_email.cc.must_include HarmanSignalProcessingWebsite::Application.config.toolkit_admin_email_addresses.first
  		last_email.body.must_include HarmanSignalProcessingWebsite::Application.config.toolkit_admin_contact_info.first
  	end
  end

  describe "Distributor Signup" do 
    before do 
      @distributor = FactoryGirl.create(:distributor)
      visit root_url(host: @host)
      within('.top-bar') do
        click_on "Sign up"
      end
      choose :signup_type_distributor
      click_on "Continue"
    end

    it "should require account number" do 
      within('#new_toolkit_user') do
        page.must_have_content "Harman Pro Account Number"
        click_on "Sign up"
      end
      page.must_have_content "email address on file.can't be blank"
    end

    it "should create a new unconfirmed user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_distributor_user_form(user, @distributor)
        click_on "Sign up"
      end
      u = User.last
      u.confirmed?.must_equal(false)
    end     

    it "should associate the user with the distributor by account number" do 
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_distributor_user_form(user, @distributor)
        click_on "Sign up"
      end
      u = User.last
      u.distributors.must_include(@distributor)
    end

    it "should send the confirmation email to the distributor not the user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_distributor_user_form(user, @distributor)
        click_on "Sign up"
      end
      last_email.subject.must_match "Harman Toolkit Confirmation instructions"
      last_email.to.must_include(@distributor.email)
      last_email.body.must_include user.name
      last_email.body.must_include user.email
    end     
  end

  describe "Invalid Distributor Signup" do
    before do
      visit root_url(host: @host)
      within('.top-bar') do
        click_on "Sign up"
      end
      choose :signup_type_distributor
      click_on "Continue"
    end

    it "should send an email error to user where no distributor is found" do 
      user = FactoryGirl.build(:user)
      distributor = FactoryGirl.build(:distributor) # un-saved, so should error when looking up
      within('#new_toolkit_user') do
        fill_in_new_distributor_user_form(user, distributor)
        click_on "Sign up"
      end
      last_email.subject.must_match "can't confirm account"
      last_email.to.must_include(user.email)
      last_email.cc.must_include HarmanSignalProcessingWebsite::Application.config.toolkit_admin_email_addresses.first
      last_email.body.must_include HarmanSignalProcessingWebsite::Application.config.toolkit_admin_contact_info.first
    end
  end

  describe "RSO Signup" do 
    before do 
      visit root_url(host: @host)
      within('.top-bar') do
        click_on "Sign up"
      end
      choose :signup_type_rso
      click_on "Continue"
    end

    it "should NOT require account number" do 
      within('#new_toolkit_user') do
        page.wont_have_content "Harman Pro Account Number"
      end
    end

    it "should require invitation code" do 
      within('#new_toolkit_user') do
        page.must_have_content "Invitation code"
        fill_in :toolkit_user_invitation_code, with: "something wrong"
        click_on "Sign up"
      end
      page.must_have_content "it is cAsE sEnSiTiVe."
    end

    it "should create a new unconfirmed user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_rso_user_form(user) 
        click_on "Sign up"
      end
      u = User.last
      u.confirmed?.must_equal(false)
    end     

    it "should send the confirmation email to the new user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_rso_user_form(user)
        click_on "Sign up"
      end
      last_email.subject.must_match "HSP Toolkit Confirmation link"
      last_email.to.must_include(user.email)
      last_email.body.must_include user.name
      last_email.body.must_include user.email
    end     
  end

  describe "Employee Signup" do 
    before do 
      visit root_url(host: @host)
      within('.top-bar') do
        click_on "Sign up"
      end
      choose :signup_type_employee
      click_on "Continue"
    end

    it "should NOT require account number" do 
      within('#new_toolkit_user') do
        page.wont_have_content "Harman Pro Account Number"
      end
    end

    it "should require invitation code" do 
      within('#new_toolkit_user') do
        page.must_have_content "Invitation code"
        fill_in :toolkit_user_invitation_code, with: "something wrong"
        click_on "Sign up"
      end
      page.must_have_content "it is cAsE sEnSiTiVe."
    end

    it "should create a new unconfirmed user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_employee_user_form(user) 
        click_on "Sign up"
      end
      u = User.last
      u.confirmed?.must_equal(false)
    end     

    it "should send the confirmation email to the new user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_employee_user_form(user)
        click_on "Sign up"
      end
      last_email.subject.must_match "HSP Toolkit Confirmation link"
      last_email.to.must_include(user.email)
      last_email.body.must_include user.name
      last_email.body.must_include user.email
    end     
  end

  describe "Media Signup" do 
    before do 
      visit root_url(host: @host)
      within('.top-bar') do
        click_on "Sign up"
      end
      choose :signup_type_media
      click_on "Continue"
    end

    it "should NOT require account number" do 
      within('#new_toolkit_user') do
        page.wont_have_content "Harman Pro Account Number"
      end
    end

    it "should require invitation code" do 
      within('#new_toolkit_user') do
        page.must_have_content "Invitation code"
        fill_in :toolkit_user_invitation_code, with: "something wrong"
        click_on "Sign up"
      end
      page.must_have_content "it is cAsE sEnSiTiVe."
    end

    it "should create a new unconfirmed user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_media_user_form(user) 
        click_on "Sign up"
      end
      u = User.last
      u.confirmed?.must_equal(false)
    end     

    it "should send the confirmation email to the new user" do
      user = FactoryGirl.build(:user)
      within('#new_toolkit_user') do
        fill_in_new_media_user_form(user)
        click_on "Sign up"
      end
      last_email.subject.must_match "HSP Toolkit Confirmation link"
      last_email.to.must_include(user.email)
      last_email.body.must_include user.name
      last_email.body.must_include user.email
    end     
  end

  ######### Devise changed, doesn't seem possible to get the same confirmation token directly.
  ######### I'd have to read the email that was sent to the user and click on the link in it.
  describe "Confirmation" do 
  	it "should confirm the new user" do
  		@dealer = FactoryGirl.create(:dealer)
  		@user = FactoryGirl.create(:user, dealer: true, account_number: @dealer.account_number)
  		@user.confirmed?.must_equal(false)
  		# visit toolkit_user_confirmation_url(:confirmation_token => @user.confirmation_token, host: @host)
      last_email.body.to_s.match(/href\=\"(.*)\"+/)
      visit $1
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
  		page.must_have_content "Signed in successfully"
  	end

  	it "wont show login link after logging in" do
  		page.wont_have_link "Login"
  		page.wont_have_link "Sign up"
  	end

  	it "will have a link to manage account" do
  		page.must_have_link "My account"
  	end

  	it "will have a logout link" do
  		page.must_have_link "Logout"
  		click_on "Logout"
  		page.must_have_link "Login"
  	end		
  end

	def fill_in_new_dealer_user_form(user, dealer)
		fill_in :toolkit_user_name, with: user.name
		fill_in :toolkit_user_email, with: user.email
		fill_in :toolkit_user_account_number, with: dealer.account_number
		fill_in :toolkit_user_password, with: "pass123"
		fill_in :toolkit_user_password_confirmation, with: "pass123"  		
	end

  def fill_in_new_distributor_user_form(user, distributor)
    fill_in :toolkit_user_name, with: user.name
    fill_in :toolkit_user_email, with: user.email
    fill_in :toolkit_user_account_number, with: distributor.account_number
    fill_in :toolkit_user_password, with: "pass123"
    fill_in :toolkit_user_password_confirmation, with: "pass123"      
  end

  def fill_in_new_rso_user_form(user)
    fill_in :toolkit_user_name, with: user.name
    fill_in :toolkit_user_email, with: user.email
    fill_in :toolkit_user_invitation_code, with: HarmanSignalProcessingWebsite::Application.config.rso_invitation_code
    fill_in :toolkit_user_password, with: "pass123"
    fill_in :toolkit_user_password_confirmation, with: "pass123"      
  end

  def fill_in_new_employee_user_form(user)
    fill_in :toolkit_user_name, with: user.name
    fill_in :toolkit_user_email, with: user.email
    fill_in :toolkit_user_invitation_code, with: HarmanSignalProcessingWebsite::Application.config.employee_invitation_code
    fill_in :toolkit_user_password, with: "pass123"
    fill_in :toolkit_user_password_confirmation, with: "pass123"      
  end

  def fill_in_new_media_user_form(user)
    fill_in :toolkit_user_name, with: user.name
    fill_in :toolkit_user_email, with: user.email
    fill_in :toolkit_user_invitation_code, with: HarmanSignalProcessingWebsite::Application.config.media_invitation_code
    fill_in :toolkit_user_password, with: "pass123"
    fill_in :toolkit_user_password_confirmation, with: "pass123"      
  end

end
