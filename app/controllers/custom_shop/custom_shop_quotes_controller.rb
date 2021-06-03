class CustomShop::CustomShopQuotesController < CustomShopController
  before_action :authenticate_user!, only: [:edit, :request_quote, :request_submitted]

  def build_quote
    render action: 'edit'
  end

  def edit
  end

  def request_quote
    @custom_shop_quote.update(custom_shop_quote_attributes)
    @custom_shop_quote.update(user_id: current_user.id)
    CustomShopMailer.delay.request_quote(@custom_shop_quote)
    redirect_to custom_shop_request_submitted_path and return false
  end

  def request_submitted
    session.delete(:custom_shop_quote_id)
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

