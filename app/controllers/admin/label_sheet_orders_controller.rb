class Admin::LabelSheetOrdersController < AdminController
  before_action :initialize_label_sheet_order, only: :create
  load_and_authorize_resource

  # GET /label_sheet_orders
  # GET /label_sheet_orders.xml
  def index
    @search = LabelSheetOrder.ransack(params[:q])
    if params[:q]
      @label_sheet_orders = @search.result.order(:name)
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @label_sheet_orders }
      format.xls {
        send_data(@label_sheet_orders.to_a.to_xls(
          headers: ["Name", "Address", "City", "State", "Zip", "Country", "Email", "Subscribe", "Created"],
          columns: [:name, :address, :city, :state, :postal_code, :country, :email, :subscribe, :created_at])
        )
      }
    end
  end

  def subscribers
    @label_sheet_orders = @label_sheet_orders.where(subscribe: true)
    index
  end

  # GET /label_sheet_orders/1
  # GET /label_sheet_orders/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @label_sheet_order }
    end
  end

  # GET /label_sheet_orders/new
  # GET /label_sheet_orders/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @label_sheet_order }
    end
  end

  # GET /label_sheet_orders/1/edit
  def edit
  end

  # POST /label_sheet_orders
  # POST /label_sheet_orders.xml
  def create
    respond_to do |format|
      if @label_sheet_order.save
        format.html { redirect_to([:admin, @label_sheet], notice: 'Label Sheet Order was successfully created.') }
        format.xml  { render xml: @label_sheet, status: :created, location: @label_sheet_order }
        website.add_log(user: current_user, action: "Created Label Sheet Order: #{@label_sheet_order.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @label_sheet_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /label_sheet_orders/1
  # PUT /label_sheet_orders/1.xml
  def update
    respond_to do |format|
      if @label_sheet_order.update(label_sheet_order_params)
        format.html { redirect_to([:admin, @label_sheet], notice: 'Label Sheet Order was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated Label Sheet Order: #{@label_sheet_order.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @label_sheet_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /label_sheet_orders/1
  # DELETE /label_sheet_orders/1.xml
  def destroy
    @label_sheet_order.destroy
    respond_to do |format|
      format.html { redirect_to(admin_label_sheet_orders_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted Label Sheet Order: #{@label_sheet_order.name}")
  end

  private

  def initialize_label_sheet_order
    @label_sheet_order = LabelSheetOrder.new(label_sheet_order_params)
  end

  def label_sheet_order_params
    params.require(:label_sheet_order).permit!
  end
end
