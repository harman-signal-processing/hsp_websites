class Admin::SalesRegionsController < AdminController
  before_action :initialize_sales_region, only: :create
  load_and_authorize_resource

  # GET /admin/sales_regions
  # GET /admin/sales_regions.xml
  def index
    @sales_regions = website.brand.sales_regions.order(:name)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @sales_regions }
    end
  end

  # GET /admin/sales_regions/1
  # GET /admin/sales_regions/1.xml
  def show
    @sales_region_country = SalesRegionCountry.new(sales_region: @sales_region)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @sales_region }
    end
  end

  # GET /admin/sales_regions/new
  # GET /admin/sales_regions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @sales_region }
    end
  end

  # GET /admin/sales_regions/1/edit
  def edit
  end

  # POST /admin/sales_regions
  # POST /admin/sales_regions.xml
  def create
    @sales_region.brand = website.brand
    respond_to do |format|
      if @sales_region.save
        format.html { redirect_to([:admin, @sales_region], notice: 'Sales Region was successfully created.') }
        format.xml  { render xml: @sales_region, status: :created, location: @sales_region }
        website.add_log(user: current_user, action: "Created Sales Region #{@sales_region.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @sales_region.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sales_regions/1
  # PUT /admin/sales_regions/1.xml
  def update
    respond_to do |format|
      if @sales_region.update(sales_region_params)
        format.html { redirect_to([:admin, @sales_region], notice: 'Sales Region was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated Sales Region #{@sales_region.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @sales_region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sales_regions/1
  # DELETE /admin/sales_regions/1.xml
  def destroy
    @sales_region.destroy
    respond_to do |format|
      format.html { redirect_to(admin_sales_regions_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted Sales Region #{@sales_region.name}")
  end

  private

  def initialize_sales_region
    @sales_region = SalesRegion.new(sales_region_params)
  end

  def sales_region_params
    params.require(:sales_region).permit(:name, :brand_id, :support_email)
  end
end

