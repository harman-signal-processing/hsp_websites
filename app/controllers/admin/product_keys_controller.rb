class Admin::ProductKeysController < AdminController
  before_action :load_product
  load_and_authorize_resource except: :index

  def index
    @product_stock_subscription = ProductStockSubscription.where(user_id: current_user.id, product_id: @product.id).first_or_initialize
  end

  def create
    if params[:new_keys].present?
      new_key_data = params[:new_keys].split(/\r\n/).map do |key|
        {
          key: key,
          product_id: @product.id
        }
      end
      if ProductKey.create!( new_key_data )
        if params[:return_to]
          return_to = URI.parse(params[:return_to]).path
          redirect_to(return_to, notice: "Product keys were successfully added to inventory.")
        else
          redirect_to admin_product_product_keys_path(@product), notice: "The new product keys were added."
        end
      else
        redirect_to action: :index, alert: "There was a problem with the keys."
      end
    end
  end

  private

  def load_product
    @product = Product.find(params[:product_id])
  end

end
