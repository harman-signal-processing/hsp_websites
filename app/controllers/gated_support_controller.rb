class GatedSupportController < ApplicationController
  skip_before_action :verify_authenticity_token, :ensure_locale_for_site, raise: false
  before_action :store_user_location!, if: :storable_location?
  # before_action :require_admin_authentication
  before_action :authenticate_user!
  check_authorization
  skip_authorization_check

  def index
    render_template
  end

  def super_tech_upgrade
    if current_user && current_user.technician?
      current_user.update(super_technician: true, technician: false)
      redirect_to gated_support_path, notice: "You now have super-tech level access. Enjoy!"
    else
      redirect_to gated_support_path, alert: "Sorry, your account must first have \"Technician\" access in order to be upgraded."
    end
  end

end

