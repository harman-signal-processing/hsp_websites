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
      visit admin_root_path
    end

  end
end
