class Admin::ClinicProductsController < AdminController
  load_and_authorize_resource
  # GET /clinic_products
  # GET /clinic_products.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @clinic_products }
    end
  end

  # GET /clinic_products/1
  # GET /clinic_products/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @clinic_product }
    end
  end

  # GET /clinic_products/new
  # GET /clinic_products/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @clinic_product }
    end
  end

  # GET /clinic_products/1/edit
  def edit
  end

  # POST /clinic_products
  # POST /clinic_products.xml
  def create
    respond_to do |format|
      if @clinic_product.save
        format.html { redirect_to([:admin, @clinic_product], notice: 'Clinic product was successfully created.') }
        format.xml  { render xml: @clinic_product, status: :created, location: @clinic_product }
        website.add_log(user: current_user, action: "Added #{@clinic_product.product.name} to #{@clinic_product.clinic.location} clinic")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @clinic_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clinic_products/1
  # PUT /clinic_products/1.xml
  def update
    respond_to do |format|
      if @clinic_product.update_attributes(params[:clinic_product])
        format.html { redirect_to([:admin, @clinic_product], notice: 'Clinic product was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated #{@clinic_product.product.name} for #{@clinic_product.clinic.location} clinic")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @clinic_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clinic_products/1
  # DELETE /clinic_products/1.xml
  def destroy
    @clinic_product.destroy
    respond_to do |format|
      format.html { redirect_to(admin_clinic_products_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Removed #{@clinic_product.product.name} from #{@clinic_product.clinic.location} clinic")
  end
end
