class Admin::VipProgrammerLocationsController < AdminController
	before_action :initialize_vip_programmer_location, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerLocation", except: [:update_order]
  skip_authorization_check only: [:update_order]
  
  
  # GET /admin/vip_programmer_locations
  # GET /admin/vip_programmer_locations.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_location }
    end
  end

  # GET /admin/vip_programmer_locations/1
  # GET /admin/vip_programmer_locations/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_location }
    end
  end  
  
  
  # GET /admin/vip_programmer_locations/new
  # GET /admin/vip_programmer_locations/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_location }
    end
  end

  # GET /admin/vip_programmer_locations/1/edit
  def edit
  end
  
  # POST /admin/vip_programmer_locations
  # POST /admin/vip_programmer_locations.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_location.save
        format.html { redirect_to([:admin, @vip_programmer_location], notice: 'Programmer location was successfully created.') }
        format.xml  { render xml: @vip_programmer_location, status: :created, location: @vip_programmer_location }
        format.js 
        website.add_log(user: current_user, action: "Associated a location with #{@vip_programmer_location.programmer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_programmer_location.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_programmer_locations/create_error" }
      end
    end
  end  
  
  
  # PUT /admin/vip_programmer_locations/1
  # PUT /admin/vip_programmer_locations/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_location.update_attributes(vip_programmer_location_params)
        format.html { redirect_to([:admin, @vip_programmer_location], notice: 'Programmer location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_location.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update_order
    update_list_order(Vip::ProgrammerLocation, params["vip_programmer_location"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted VIP programmer locations")    
  end
  
  # DELETE /admin/vip_programmer_locations/1
  # DELETE /admin/vip_programmer_locations/1.xml
  def destroy
    @vip_programmer_location.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_locations_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a location from #{@vip_programmer_location.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_location
	    @vip_programmer_location = Vip::ProgrammerLocation.new(vip_programmer_location_params)
	  end
	
	  def vip_programmer_location_params
	    params.require(:vip_programmer_location).permit!
	  end
end
