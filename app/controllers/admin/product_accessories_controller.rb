class Admin::ProductAccessoriesController < AdminController
  before_action :initialize_product_accessory, only: :create
  load_and_authorize_resource

  # GET /admin/product_accessories
  # GET /admin/product_accessories.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_accessories }
    end
  end

  # GET /admin/product_accessories/1
  # GET /admin/product_accessories/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_accessory }
    end
  end

  # GET /admin/product_accessories/new
  # GET /admin/product_accessories/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_accessory }
    end
  end

  # GET /admin/product_accessories/1/edit
  def edit
  end

  # POST /admin/product_accessories
  # POST /admin/product_accessories.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_accessory.save
        format.html { redirect_to([:admin, @product_accessory.product], notice: 'Product Accessory was successfully created.') }
        format.xml  { render xml: @product_accessory, status: :created, location: @product_accessory }
        format.js
        website.add_log(user: current_user, action: "Added accessory to #{@product_accessory.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_accessory.errors, status: :unprocessable_entity }
        format.js { render template: "admin/product_accessories/create_error" }
      end
    end
  end

  # PUT /admin/product_accessories/1
  # PUT /admin/product_accessories/1.xml
  def update
    respond_to do |format|
      if @product_accessory.update(product_accessory_params)
        format.html { redirect_to([:admin, @product_accessory], notice: 'Product Accessory was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product accessory for #{@product_accessory.product.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_accessory.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_accessories/update_order
  def update_order
    update_list_order(ProductAccessory, params["product_accessory"])
    head :ok
    website.add_log(user: current_user, action: "Sorted product accessories")
  end

  # DELETE /admin/product_accessories/1
  # DELETE /admin/product_accessories/1.xml
  def destroy
    @product_accessory.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_accessories_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed product accessory from #{@product_accessory.product.name}")
  end

  private

  def initialize_product_accessory
    @product_accessory = ProductAccessory.new(product_accessory_params)
  end

  def product_accessory_params
    params.require(:product_accessory).permit!
  end
end

