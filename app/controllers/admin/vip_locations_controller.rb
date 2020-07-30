class Admin::VipLocationsController < AdminController
  load_and_authorize_resource class: "Vip::Location"
  
  # GET /vip_locations
  # GET /vip_locations.xml
  # GET /vip_locations.json
  def index
    @vip_locations = Vip::Location.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_locations }
      format.json  { render json: @vip_locations }
    end
  end
  
  def show
    @vip_global_regions = Vip::GlobalRegion.all.order(:name)
    @vip_location_global_region = Vip::LocationGlobalRegion.new(vip_location_id: @vip_location.id)
    @vip_location_global_regions = Vip::LocationGlobalRegion.where(vip_location_id: @vip_location.id)
    
    @vip_service_areas = Vip::ServiceArea.all.order(:name)
    @vip_location_service_area = Vip::LocationServiceArea.new(vip_location_id: @vip_location.id)
    @vip_location_service_areas = Vip::LocationServiceArea.where(vip_location_id: @vip_location.id)    
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_location = Vip::Location.find(params[:id])
    respond_to do |format|
      if @vip_location.update(vip_location_params)
        format.html { redirect_to(admin_vip_locations_path, notice: 'AMX VIP Location was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip location: #{@vip_location.name} - #{@vip_location.city}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_location.errors, status: :unprocessable_entity }
      end
    end    
  end
  
  def create
    @vip_location = Vip::Location.new(vip_location_params)
    respond_to do |format|
      if @vip_location.save

        format.html { redirect_to(admin_vip_locations_path, notice: 'AMX VIP Location was successfully created.') }
        format.xml  { render xml: @vip_location, status: :created, location: @vip_location }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip location #{@vip_location.name} - #{@vip_location.city}")
      else
        format.html { redirect_to(admin_vip_locations_path, notice: 'There was a problem creating the AMX VIP Location.') }
        format.xml  { render xml: @vip_location.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end     
  end
  
  # DELETE /vip_locations/1
  # DELETE /vip_locations/1.xml
  def destroy
    @vip_location.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_locations_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted an amx vip location: #{@vip_location.name} - #{@vip_location.city}")
  end   
  
  private
  
    def vip_location_params
  	  params.require(:vip_location).permit!
    end 
  
end
