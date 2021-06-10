class CustomShop::CustomShopQuotesController < CustomShopController
  before_action :set_custom_shop_cart
  before_action :authenticate_user!

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

  def request_submitted
    session.delete(:custom_shop_cart_id)
  end

  private

  def custom_shop_quote_attributes
    params.require(:custom_shop_quote).permit(
      :account_number,
      :opporunity_number,
      :opportunity_name,
      :location,
      :request_delivery_on,
      :description
    )
  end

end

