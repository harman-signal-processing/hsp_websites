module Features
  module SessionHelpers

     def sign_up_with(email, password, confirmation)
       visit new_user_registration_path
       fill_in 'Email', with: email
       fill_in 'Password', with: password
       fill_in 'Password confirmation', :with => confirmation
       click_button 'Sign up'
     end

    def signin(email, password)
      visit new_user_session_path
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end

    def admin_login_with(email, password, website)
      visit new_user_session_url(host: website.url)
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign in'
    end

    def setup_and_login_queue_user
      host = HarmanSignalProcessingWebsite::Application.config.queue_url
      @password = "pass123"
      @user = FactoryGirl.create(:user,
                                 marketing_staff: true,
                                 name: "Johnny Danger",
                                 password: @password,
                                 password_confirmation: @password)
      @user.confirm
      visit new_marketing_queue_user_session_url(host: host)
      fill_in :marketing_queue_user_email, with: @user.email
      fill_in :marketing_queue_user_password, with: @password
      click_on "Sign in"
    end

    def setup_and_login_queue_admin
      host = HarmanSignalProcessingWebsite::Application.config.queue_url
      @password = "pass123"
      @user = FactoryGirl.create(:user,
                                 marketing_staff: true,
                                 name: "Jason Kunz",
                                 queue_admin: true,
                                 password: @password,
                                 password_confirmation: @password)
      @user.confirm
      visit new_marketing_queue_user_session_url(host: host)
      fill_in :marketing_queue_user_email, with: @user.email
      fill_in :marketing_queue_user_password, with: @password
      click_on "Sign in"
    end

    def setup_and_login_market_manager
      host = HarmanSignalProcessingWebsite::Application.config.queue_url
      @password = "pass123"
      @user = FactoryGirl.create(:user,
                                 marketing_staff: true,
                                 name: "G. Scott",
                                 market_manager: true,
                                 password: @password,
                                 password_confirmation: @password)
      @user.confirm
      visit new_marketing_queue_user_session_url(host: host)
      fill_in :marketing_queue_user_email, with: @user.email
      fill_in :marketing_queue_user_password, with: @password
      click_on "Sign in"
    end

  end
end
