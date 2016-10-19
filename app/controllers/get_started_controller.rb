class GetStartedController < ApplicationController
  before_filter :set_locale
  before_filter :load_this_brands_get_started_pages

  def index
  end

  def show
    @get_started_page = @get_started_pages.find(params[:id])
    @warranty_registration = WarrantyRegistration.new
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
