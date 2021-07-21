class CustomShop::CustomShopQuotesController < CustomShopController
  before_action :set_custom_shop_cart, only: [:new, :create]
  before_action :authenticate_user!
  load_and_authorize_resource only: [:index, :show, :edit, :update]

  def index
    @search = CustomShopQuote.ransack(params[:q])
    if params[:q]
      @custom_shop_quotes = @search.result
    else
      @custom_shop_quotes = @custom_shop_quotes.order("created_at DESC")
    end
    @custom_shop_quotes = @custom_shop_quotes.paginate(page: params[:page], per_page: 30)
  end

  def show
    @custom_shop_quote = CustomShopQuote.find(params[:id])
  end

  def new
    @custom_shop_quote = CustomShopQuote.new
  end

  def edit
  end

  def create
    @custom_shop_quote = CustomShopQuote.new(custom_shop_quote_attributes)
    @custom_shop_quote.user_id = current_user.id
    @custom_shop_quote.custom_shop_cart_id = @custom_shop_cart.id
    @custom_shop_quote.save!

    redirect_to custom_shop_request_submitted_path and return false
  end

  def update
    respond_to do |f|
      if @custom_shop_quote.update(attributes_for_update)
        f.html { redirect_to [:custom_shop, @custom_shop_quote], notice: "Quote was updated successfully" }
      else
        f.html { render action: "edit" }
      end
    end
  end

  def request_submitted
    session.delete(:custom_shop_cart_id)
  end

  private

  def custom_shop_quote_attributes
    params.require(:custom_shop_quote).permit(
      :account_number,
      :opportunity_number,
      :opportunity_name,
      :location,
      :request_delivery_on,
      :description
    )
  end

  def attributes_for_update
    params.require(:custom_shop_quote).permit(
      :status,
      custom_shop_line_items_attributes: [:price, :id]
    )
  end
end

