class Admin::VipLocationGlobalRegionsController < AdminController
	before_action :initialize_vip_location_global_region, only: :create
  load_and_authorize_resource class: "Vip::LocationGlobalRegion"
  
  # GET /admin/vip_location_global_regions
  # GET /admin/vip_location_global_regions.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_location_global_region }
    end
  end  
  
  # GET /admin/vip_location_global_regions/1
  # GET /admin/vip_location_global_regions/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_location_global_region }
    end
  end   
  
  # GET /admin/vip_location_global_regions/new
  # GET /admin/vip_location_global_regions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_location_global_region }
    end
  end

  # GET /admin/vip_location_global_regions/1/edit
  def edit
  end  
  
  # POST /admin/vip_location_global_regions
  # POST /admin/vip_location_global_regions.xml
  def create
    @called_from = params[:called_from] || "vip_location"
    respond_to do |format|
      if @vip_location_global_region.save
        format.html { redirect_to([:admin, @vip_location_global_region], notice: 'Location global region was successfully created.') }
        format.xml  { render xml: @vip_location_global_region, status: :created, location: @vip_location_global_region }
        format.js 
        website.add_log(user: current_user, action: "Associated a global region with #{@vip_location_global_region.location.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_location_global_region.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_location_global_region/create_error" }
      end
    end
  end   
  
  # PUT /admin/vip_location_global_regions/1
  # PUT /admin/vip_location_global_regions/1.xml
  def update
    respond_to do |format|
      if @vip_location_global_region.update_attributes(vip_location_global_region_params)
        format.html { redirect_to([:admin, @vip_location_global_region], notice: 'Location global region was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_location_global_region.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # DELETE /admin/vip_location_global_regions/1
  # DELETE /admin/vip_location_global_regions/1.xml
  def destroy
    @vip_location_global_region.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_location_global_regions_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a global region from #{@vip_location_global_region.location.name}")
  end    
  
  private

	  def initialize_vip_location_global_region
	    @vip_location_global_region = Vip::LocationGlobalRegion.new(vip_location_global_region_params)
	  end
	
	  def vip_location_global_region_params
	    params.require(:vip_location_global_region).permit!
	  end
end
