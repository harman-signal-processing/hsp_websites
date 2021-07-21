class CustomShop::ProductsController < CustomShopController
  before_action :load_product, only: :show

  # Convenience route so we can link_to [:custom_shop, @product]
  # to start a new line item for a custom_shop_cart
  def show
    redirect_to new_custom_shop_custom_shop_line_item_path(product_id: @product)
  end

  private

  def load_product
    begin
      @product = Product.where(cached_slug: params[:id]).first || Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to custom_shop_path and return
    end
    unless @product.belongs_to_this_brand?(website)
      redirect_to custom_shop_path and return
    end
  end

end


