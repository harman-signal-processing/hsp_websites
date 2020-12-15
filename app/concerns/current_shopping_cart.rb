module CurrentShoppingCart

  private

  def set_cart
    @shopping_cart = ShoppingCart.find(session[:shopping_cart_id])
  rescue ActiveRecord::RecordNotFound
    @shopping_cart = ShoppingCart.create
    session[:shopping_cart_id] = @shopping_cart.id
  end

end
