class LineItemsController < ApplicationController
  include CurrentShoppingCart
  before_action :set_locale, :set_cart, :load_line_item

  def update
    respond_to do |format|
      if update_line_item
        format.html { redirect_to shopping_cart_path, notice: "Your cart was updated." }
      else
        format.html { redirect_to shopping_cart_path, alert: "There was a problem updating your cart." }
      end
    end
  end

  private

  # Only select line_items from the current shopping cart
  def load_line_item
    @line_item = @shopping_cart.line_items.find(params[:id])
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end

  def update_line_item
    if line_item_params[:quantity].to_i > @line_item.product.available_product_keys.length
      @line_item.update(quantity: @line_item.product.available_product_keys.length)
    else
      @line_item.update(line_item_params)
    end
  end

end
