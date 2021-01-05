class ShoppingCartController < ApplicationController
  include CurrentShoppingCart
  before_action :set_locale, :set_cart
  before_action :load_product, only: [:add_item, :remove_item]

  def add_item
    @shopping_cart.add_item(@product)
    redirect_to shopping_cart_path
  end

  def remove_item
    @shopping_cart.remove_item(@product)
    redirect_to shopping_cart_path
  end

  def show
  end

  def details
    render json: {
      total_cents: @shopping_cart.total_cents,
      currency: "USD"
    }
  end

  private

  def load_product
    @product = Product.find(params[:id])
  end

end
