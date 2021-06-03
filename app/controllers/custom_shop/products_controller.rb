class CustomShop::ProductsController < CustomShopController
  before_action :load_product, only: :show

  def show
    @custom_shop_quote_line_item = CustomShopQuoteLineItem.new(product: @product)
  end

  private

  def load_product
    begin
      @product = Product.where(cached_slug: params[:id]).first || Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to search_path(query: params[:id].to_s.gsub(/\_|\-/, " ")) and return false
    end
    unless @product.belongs_to_this_brand?(website)
      redirect_to custom_shop_path and return
    end
  end

end


