module CurrentCustomShopCart

  private

  def set_custom_shop_cart
    if session[:custom_shop_cart_id].present?
      @custom_shop_cart = CustomShopCart.find(session[:custom_shop_cart_id])
    elsif params[:uuid].present?
      @custom_shop_cart = CustomShopCart.find(uuid: params[:uuid]).first_or_create
    else
      @custom_shop_cart = CustomShopCart.create
    end

    session[:custom_shop_cart_id] = @custom_shop_cart.id
  end
end
