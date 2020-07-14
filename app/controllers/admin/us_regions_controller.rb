class Admin::UsRegionsController < AdminController
  before_action :initialize_us_region, only: :create
  load_and_authorize_resource
  
  # GET /admin/us_regions
  # GET /admin/us_regions.xml
  def index
    @search = website.brand.us_regions.ransack(params[:q])
    @us_regions = @search.result.distinct.order(:name)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @us_regions }
    end
  end

  # GET /admin/us_regions/1
  # GET /admin/us_regions/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @us_region }
    end
  end

  # GET /admin/us_regions/new
  # GET /admin/us_regions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @us_region }
    end
  end

  # GET /admin/us_regions/1/edit
  def edit
  end

  # POST /admin/us_regions
  # POST /admin/us_regions.xml
  def create
    respond_to do |format|
      if @us_region.save
        format.html { redirect_to(admin_us_reps_url, notice: 'US Region was successfully created.') }
        format.xml  { render xml: @us_region, status: :created, location: @us_region }
        website.add_log(user: current_user, action: "Created US Region #{@us_region.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @us_region.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/us_regions/1
  # PUT /admin/us_regions/1.xml
  def update
    respond_to do |format|
      if @us_region.update(us_region_params)
        format.html { redirect_to(admin_us_reps_url, notice: 'US Region was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated US Region #{@us_region.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @us_region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/us_regions/1
  # DELETE /admin/us_regions/1.xml
  def destroy
    @us_region.destroy
    respond_to do |format|
      format.html { redirect_to(admin_us_reps_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted US Region #{@us_region.name}")
  end

  private

  def initialize_us_region
    @us_region = UsRegion.new(us_region_params)
  end

  def us_region_params
    params.require(:us_region).permit!
  end
end
