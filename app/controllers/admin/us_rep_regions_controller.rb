class Admin::UsRepRegionsController < AdminController
  before_filter :initialize_us_rep_region, only: :create
  load_and_authorize_resource

  # GET /admin/us_rep_regions
  # GET /admin/us_rep_regions.xml
  def index
    @search = website.brand.us_rep_regions.ransack(params[:q])
    @us_rep_regions = @search.result.uniq.order(:name)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @us_rep_regions }
    end
  end

  # GET /admin/us_rep_regions/1
  # GET /admin/us_rep_regions/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @us_rep_region }
    end
  end

  # GET /admin/us_rep_regions/new
  # GET /admin/us_rep_regions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @us_rep_region }
    end
  end

  # GET /admin/us_rep_regions/1/edit
  def edit
  end

  # POST /admin/us_rep_regions
  # POST /admin/us_rep_regions.xml
  def create
    begin
      us_region = UsRegion.new(params.require(:us_region).permit!)
      if us_region.save
        @us_rep_region.us_region = us_region
      end
    rescue
      # probably didn't have a form that can provide a new region
    end
    respond_to do |format|
      if @us_rep_region.save!
        format.html { redirect_to([:admin, @us_rep_region.us_rep], notice: 'US Rep Region was successfully created.') }
        format.xml  { render xml: @us_rep_region, status: :created, location: @us_rep_region }
        format.js
        website.add_log(user: current_user, action: "Created US Rep Region #{@us_rep_region.us_rep.name}, #{@us_rep_region.us_region.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @us_rep_region.errors, status: :unprocessable_entity }
        format.js { render template: "admin/us_rep_regions/create_error" }
      end
    end
  end

  # PUT /admin/us_rep_regions/1
  # PUT /admin/us_rep_regions/1.xml
  def update
    respond_to do |format|
      if @us_rep_region.update_attributes(us_rep_region_params)
        format.html { redirect_to([:admin, @us_rep_region.us_rep], notice: 'US Rep Region was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated US Rep Region #{@us_rep_region.us_rep.name}, #{@us_rep_region.us_region.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @us_rep_region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/us_rep_regions/1
  # DELETE /admin/us_rep_regions/1.xml
  def destroy
    @us_rep_region.destroy
    respond_to do |format|
      format.html { redirect_to(admin_us_reps_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted US Rep Region #{@us_rep_region.us_rep.name}, #{@us_rep_region.us_region.name}")
  end

  private

  def initialize_us_rep_region
    @us_rep_region = UsRepRegion.new(us_rep_region_params)
  end

  def us_rep_region_params
    params.require(:us_rep_region).permit!
  end
end
