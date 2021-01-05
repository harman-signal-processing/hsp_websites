module ShoppingCartHelper

  def current_shopping_cart
    begin
      @current_shopping_cart ||= ShoppingCart.find(session[:shopping_cart_id])
    rescue
      nil # don't create a cart here--do that when an item is first added to cart
    end
  end

end

