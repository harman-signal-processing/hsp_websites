class CustomShop::CustomShopQuoteLineItemsController < CustomShopController
  before_action :load_product, only: :create

  def create
    @custom_shop_quote_line_item = CustomShopQuoteLineItem.new(line_item_params)
    @custom_shop_quote_line_item.product = @product
    @custom_shop_quote_line_item.custom_shop_quote = @custom_shop_quote
    respond_to do |format|
      if @custom_shop_quote_line_item.save
        format.html { redirect_to custom_shop_build_quote_path, notice: "#{@product.name} has been added to your quote." }
      else
        format.html { render template: 'custom_shop/products/show' }
      end
    end
  end

  private

  def line_item_params
    params.require(:custom_shop_quote_line_item).permit(
      :quantity,
      custom_shop_quote_line_item_attributes_attributes: [:customizable_attribute_id, :value]
    )
  end
end

