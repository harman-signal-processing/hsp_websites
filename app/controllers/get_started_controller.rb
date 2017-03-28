class GetStartedController < ApplicationController
  before_action :set_locale
  before_action :load_this_brands_get_started_pages

  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @get_started_pages }
    end
  end

  def show
    @get_started_page = @get_started_pages.find(params[:id])
    @warranty_registration = WarrantyRegistration.new
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @get_started_page }
    end
  end

  def validate
    product = Product.find(params[:warranty_registration][:product_id])
    get_started_page = product.get_started_page
    notices = {}
    if warranty_registration = WarrantyRegistration.where(registration_params).first
      cookies[get_started_page.cookie_name] = { value: warranty_registration.id, expires: 10.years.from_now }
      notices = { notice: "Your registration was found. Click the tabs below to get started." }
    else
      notices = { alert: "Your registration was not found. Try re-registering below." }
    end
    redirect_to get_started_path(get_started_page), notices
  end

  private

  def load_this_brands_get_started_pages
    @get_started_pages = website.get_started_pages
  end

  def registration_params
    params[:warranty_registration].permit(:product_id, :serial_number)
  end
end
