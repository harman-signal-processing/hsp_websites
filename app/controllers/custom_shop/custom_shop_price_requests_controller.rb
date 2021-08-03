class CustomShop::CustomShopPriceRequestsController < CustomShopController
  before_action :set_custom_shop_cart, only: [:new, :create]
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :edit, :update]

  def index
    @search = CustomShopPriceRequest.ransack(params[:q])
    if params[:q]
      @custom_shop_price_requests = @search.result
    else
      @custom_shop_price_requests = @custom_shop_price_requests.order("created_at DESC")
    end
    @custom_shop_price_requests = @custom_shop_price_requests.paginate(page: params[:page], per_page: 30)
  end

  def show
    @custom_shop_price_request = CustomShopPriceRequest.find(params[:id])
  end

  def new
    @custom_shop_price_request = CustomShopPriceRequest.new
  end

  def edit
  end

  def create
    @custom_shop_price_request = CustomShopPriceRequest.new(custom_shop_price_request_attributes)
    @custom_shop_price_request.user_id = current_user.id
    @custom_shop_price_request.custom_shop_cart_id = @custom_shop_cart.id
    @custom_shop_price_request.save!

    redirect_to custom_shop_request_submitted_path and return false
  end

  def update
    respond_to do |f|
      if @custom_shop_price_request.update(attributes_for_update)
        f.html { redirect_to [:custom_shop, @custom_shop_price_request], notice: "Price Request was updated successfully" }
      else
        f.html { render action: "edit" }
      end
    end
  end

  def request_submitted
    session.delete(:custom_shop_cart_id)
  end

  private

  def custom_shop_price_request_attributes
    params.require(:custom_shop_price_request).permit(
      :account_number,
      :opportunity_number,
      :opportunity_name,
      :location,
      :request_delivery_on,
      :description
    )
  end

  def attributes_for_update
    params.require(:custom_shop_price_request).permit(
      :status,
      custom_shop_line_items_attributes: [:price, :id]
    )
  end
end

