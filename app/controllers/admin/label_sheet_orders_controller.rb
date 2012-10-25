class Admin::LabelSheetOrdersController < AdminController
  load_and_authorize_resource 

  # GET /label_sheet_orders
  # GET /label_sheet_orders.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @label_sheet_orders }
      format.xls { 
        send_data(@label_sheet_orders.to_xls(
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
      if @label_sheet_order.update_attributes(params[:label_sheet])
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
end
