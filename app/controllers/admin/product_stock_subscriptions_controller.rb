class Admin::ProductStockSubscriptionsController < AdminController
  before_action :initialize_product_stock_subscription, only: :create
  load_and_authorize_resource

  def new
    if params[:product_id].present?
      @product_stock_subscription.product_id = params[:product_id]
    end
  end

  def edit
  end

  def create
    @product_stock_subscription.user = current_user
    respond_to do |format|
      if @product_stock_subscription.save
        format.html { redirect_to(redirect_location, notice: 'Your subscription is all set.') }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @product_stock_subscription.update(product_stock_subscription_params)
        format.html { redirect_to(redirect_location, notice: 'Your subscription was updated.') }
      else
        format.html { render action: "edit" }
      end
    end
  end

  private

  def redirect_location
    admin_product_product_keys_path(@product_stock_subscription.product)
  end

  def initialize_product_stock_subscription
    @product_stock_subscription = ProductStockSubscription.new(product_stock_subscription_params)
  end

  def product_stock_subscription_params
    params.require(:product_stock_subscription).permit(:product_id, :low_stock_level)
  end
end
