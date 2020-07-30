class Admin::VipLocationServiceAreasController < AdminController
	before_action :initialize_vip_location_service_area, only: :create
  load_and_authorize_resource class: "Vip::LocationServiceArea"	
  
  
  # GET /admin/vip_location_service_areas
  # GET /admin/vip_location_service_areas.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_location_service_area }
    end
  end  
  
  # GET /admin/vip_location_service_areas/1
  # GET /admin/vip_location_service_areas/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_location_service_area }
    end
  end  
  
  # GET /admin/vip_location_service_areas/new
  # GET /admin/vip_location_service_areas/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_location_service_area }
    end
  end

  # GET /admin/vip_location_service_areas/1/edit
  def edit
  end   
  
  # POST /admin/vip_location_service_areas
  # POST /admin/vip_location_service_areas.xml
  # def create
  #   @called_from = params[:called_from] || "vip_location"
  #   respond_to do |format|
  #     if @vip_location_service_area.save
  #       format.html { redirect_to([:admin, @vip_location_service_area], notice: 'Location service area was successfully created.') }
  #       format.xml  { render xml: @vip_location_service_area, status: :created, location: @vip_location_service_area }
  #       format.js 
  #       website.add_log(user: current_user, action: "Associated a service area with #{@vip_location_service_area.location.name}")
  #     else
  #       format.html { render action: "new" }
  #       format.xml  { render xml: @vip_location_service_area.errors, status: :unprocessable_entity }
  #       format.js { render template: "admin/vip_location_service_area/create_error" }
  #     end
  #   end
  # end   
  def create
    @called_from = params[:called_from] || "vip_location"
    respond_to do |format|
      if @vip_location_service_areas.present?
        begin
          @vip_location_service_areas.each do |vip_location_service_area|
            begin
              vip_location_service_area.save!
              website.add_log(user: current_user, action: "Associated #{vip_location_service_area.location.name} with #{vip_location_service_area.service_area.name}")
              format.js 
            rescue => e
              @error = "Error: #{e.message} : #{vip_location_service_area.service_area.name}"
              format.js { render template: "admin/vip_location_service_areas/create_error" }
            end
          end  #  @vip_location_service_areas.each do |vip_location_service_area|
          
        rescue => e
          @error = "Error: #{e.message}"
          format.js { render template: "admin/vip_location_service_areas/create_error" }
        end        
      else       
        if @vip_location_service_area.save
          format.html { redirect_to([:admin, @vip_location_service_area], notice: 'Service service category was successfully created.') }
          format.xml  { render xml: @vip_location_service_area, status: :created, location: @vip_location_service_area }
          website.add_log(user: current_user, action: "Associated #{vip_location_service_area.location.name} with #{vip_location_service_area.service_area.name}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @vip_location_service_area.errors, status: :unprocessable_entity }
          format.js { render template: "admin/vip_location_service_areas/create_error" }
        end
      end
    end  #  respond_to do |format|
  end  #  def create  
  
  # PUT /admin/vip_location_service_areas/1
  # PUT /admin/vip_location_service_areas/1.xml
  def update
    respond_to do |format|
      if @vip_location_service_area.update(vip_location_service_area_params)
        format.html { redirect_to([:admin, @vip_location_service_area], notice: 'Location service area was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_location_service_area.errors, status: :unprocessable_entity }
      end
    end
  end   
  
  # DELETE /admin/vip_location_service_areas/1
  # DELETE /admin/vip_location_service_areas/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_location"
    @vip_location_service_area.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_location_service_areas_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a service area from #{@vip_location_service_area.location.name}")
  end    
  
  private

		def initialize_vip_location_service_area
      if vip_location_service_area_params[:vip_service_area_id].is_a?(Array)
        @vip_location_service_areas = []
        vip_location_id = vip_location_service_area_params[:vip_location_id]
        vip_location_service_area_params[:vip_service_area_id].reject(&:blank?).each do |service_area|
          @vip_location_service_areas << Vip::LocationServiceArea.new({vip_location_id: vip_location_id, vip_service_area_id: service_area})
        end        
      else
        @vip_location_service_area = Vip::LocationServiceArea.new(vip_location_service_area_params)
      end	 	    
    end  #  def initialize_vip_location_service_area	
	
	  def vip_location_service_area_params
	    params.require(:vip_location_service_area).permit!
	  end  
end
