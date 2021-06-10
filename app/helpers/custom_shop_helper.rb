module CustomShopHelper

  def current_custom_shop_cart
    begin
      @current_custom_shop_cart ||= CustomShopCart.find(session[:custom_shop_cart_id])
    rescue
      nil
    end
  end

end
