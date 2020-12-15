class ShoppingCartController < ApplicationController
  include CurrentShoppingCart
  before_action :set_locale, :set_cart

  def add_item
    @product = Product.find(params[:id])
    @shopping_cart.add_item(@product)
    redirect_to shopping_cart_path
  end

  def show
  end
end
