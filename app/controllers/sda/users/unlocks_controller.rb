class Sda::Users::UnlocksController < Devise::UnlocksController
  before_filter :set_nav_and_footer_links
  
  
end