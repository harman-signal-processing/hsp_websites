class Admin::SalesOrdersController < AdminController
  load_and_authorize_resource except: :index

  def index
    authorize! :read, SalesOrder
    @search = SalesOrder.ransack(params[:q])
    if params[:q]
      @sales_orders = @search.result.includes(:user)
    else
      @sales_orders = SalesOrder.order("id DESC").limit(20)
    end
  end

  def show
  end

end

