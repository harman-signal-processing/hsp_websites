class PartsController < ApplicationController
  skip_before_action :verify_authenticity_token, :ensure_locale_for_site, raise: false
  before_action :store_user_location!, if: :storable_location?
  # before_action :require_admin_authentication
  before_action :authenticate_user!
  check_authorization
  skip_authorization_check only: [:index]

  # GET /parts
  # GET /parts.xml
  #  This should be limited to the brand, but only Martin uses it currently
  def index
    if can?(:read, Part)
      @parts = Part.ransack(params[:q])
      @searched = false
      @search_results = []
      if params[:q]
        @search_results = @parts.result(:distinct => true)
        @searched = true
      end
      render_template
    else
      redirect_to root_path
    end
  end


end
