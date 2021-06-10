class CustomShop::CustomShopLineItemsController < CustomShopController
  before_action :set_custom_shop_cart, except: :new
  before_action :load_product, only: :new
  before_action :load_line_item, only: [:edit, :update, :destroy]

  def new
    @custom_shop_line_item = CustomShopLineItem.new(product: @product)
    @custom_shop_line_item.build_options
  end

  def create
    @custom_shop_line_item = CustomShopLineItem.new(line_item_params)
    @custom_shop_line_item.custom_shop_cart = @custom_shop_cart
    respond_to do |format|
      if @custom_shop_line_item.save
        format.html { redirect_to custom_shop_cart_path, notice: "#{@custom_shop_line_item.product.name} has been added to your quote." }
      else
        format.html { render template: 'custom_shop/products/show' }
      end
    end
  end

  # edit and new actions use same view
  def edit
    render action: 'new'
  end

  def update
    if params[:custom_shop_line_item][:quantity].to_i == 0
      destroy and return
    end
    respond_to do |format|
      if @custom_shop_line_item.update(line_item_params)
        format.html {
          redirect_to custom_shop_cart_path, notice: "#{@custom_shop_line_item.product.name} was updated."
        }
      else
        format.html { edit }
      end
    end
  end

  def destroy
    @custom_shop_line_item.destroy
    redirect_to custom_shop_cart_path, notice: "#{@custom_shop_line_item.product.name} was removed."
  end

  private

  def load_line_item
    @custom_shop_line_item = CustomShopLineItem.find(params[:id])
  end

  def line_item_params
    params.require(:custom_shop_line_item).permit(
      :product_id,
      :quantity,
      custom_shop_line_item_attributes_attributes: [:customizable_attribute_id, :value, :id]
    )
  end
end

