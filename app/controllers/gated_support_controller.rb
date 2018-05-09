class GatedSupportController < ApplicationController
  skip_before_action :verify_authenticity_token, :ensure_locale_for_site, raise: false
  before_action :store_user_location!, if: :storable_location?
  # before_action :require_admin_authentication
  before_action :authenticate_user!
  check_authorization
  skip_authorization_check only: [:index]

  def index
    render_template
  end

  private

  # Always operate admin in default locale
  def set_locale
    I18n.locale = I18n.default_locale
  end

end

