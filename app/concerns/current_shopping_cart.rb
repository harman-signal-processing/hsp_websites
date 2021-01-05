module CurrentShoppingCart

  private

  def set_cart
    if session[:shopping_cart_id].present?
      @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
    elsif params[:uuid].present?
      @shopping_cart = ShoppingCart.where(uuid: params[:uuid]).first_or_create
    else
      @shopping_cart = ShoppingCart.create
    end

    session[:shopping_cart_id] = @shopping_cart.id
  end

end
