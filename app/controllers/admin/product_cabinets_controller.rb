class Admin::ProductCabinetsController < AdminController
  before_action :initialize_product_cabinet, only: :create
  load_and_authorize_resource
  
  # GET /admin/product_cabinets
  # GET /admin/product_cabinets.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_cabinets }
    end
  end

  # GET /admin/product_cabinets/1
  # GET /admin/product_cabinets/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_cabinet }
    end
  end

  # GET /admin/product_cabinets/new
  # GET /admin/product_cabinets/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_cabinet }
    end
  end

  # GET /admin/product_cabinets/1/edit
  def edit
  end

  # POST /admin/product_cabinets
  # POST /admin/product_cabinets.xml
  def create
    begin
      cabinet = Cabinet.new(params[:cabinet])
      if cabinet.save
        @product_cabinet.cabinet = cabinet
      end
    rescue
      # probably didn't have a form that can provide a new Cabinet
    end
    @called_from = params[:called_from] || "product"
    respond_to do |format|
      if @product_cabinet.save
        format.html { redirect_to([:admin, @product_cabinet], notice: 'Product cabinet was successfully created.') }
        format.xml  { render xml: @product_cabinet, status: :created, location: @product_cabinet }
        format.js
        website.add_log(user: current_user, action: "Added cabinet #{@product_cabinet.cabinet.name} to #{@product_cabinet.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_cabinet.errors, status: :unprocessable_entity }
        format.js { render template: "admin/product_cabinets/create_error" }
      end
    end
  end

  # PUT /admin/product_cabinets/1
  # PUT /admin/product_cabinets/1.xml
  def update
    respond_to do |format|
      if @product_cabinet.update(product_cabinet_params)
        format.html { redirect_to([:admin, @product_cabinet], notice: 'Product cabinet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_cabinet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_cabinets/1
  # DELETE /admin/product_cabinets/1.xml
  def destroy
    @product_cabinet.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_cabinets_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed cabinet #{@product_cabinet.cabinet.name} from #{@product_cabinet.product.name}")
  end

  private

  def initialize_product_cabinet
    @product_cabinet = ProductCabinet.new(product_cabinet_params)
  end

  def product_cabinet_params
    params.require(:product_cabinet).permit(:product_id, :cabinet_id, cabinet: [:name])
  end
end
