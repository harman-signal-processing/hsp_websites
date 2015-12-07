class Sda::Users::PasswordsController < Devise::PasswordsController
  before_filter :set_nav_and_footer_links
  
  
end