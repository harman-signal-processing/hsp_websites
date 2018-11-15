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
      if @vip_location_global_regions.present?
        begin
          @vip_location_global_regions.each do |vip_location_global_region|
            begin
              vip_location_global_region.save!
              website.add_log(user: current_user, action: "Associated #{vip_location_global_region.location.name} with #{vip_location_global_region.global_region.name}")
              format.js
            rescue => e
              @error = "Error: #{e.message} : #{vip_location_global_region.service_category.name}"
              format.js { render template: "admin/vip_location_global_regions/create_error" }
            end
          end  #  @vip_location_global_regions.each do |vip_location_global_region|
          
        rescue => e
          @error = "Error: #{e.message}"
          format.js { render template: "admin/vip_location_global_regions/create_error" }
        end        
      else       
        if @vip_location_global_region.save
          format.html { redirect_to([:admin, @vip_location_global_region], notice: 'Service service category was successfully created.') }
          format.xml  { render xml: @vip_location_global_region, status: :created, location: @vip_location_global_region }
          format.js 
          website.add_log(user: current_user, action: "Associated #{vip_location_global_region.location.name} with #{vip_location_global_region.global_region.name}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @vip_location_global_region.errors, status: :unprocessable_entity }
          format.js { render template: "admin/vip_location_global_regions/create_error" }
        end
      end
    end  #  respond_to do |format|
  end  #  def create   
  
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
    @called_from = params[:called_from] || "vip_location"
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
      if vip_location_global_region_params[:vip_global_region_id].is_a?(Array)
        @vip_location_global_regions = []
        vip_location_id = vip_location_global_region_params[:vip_location_id]
        vip_location_global_region_params[:vip_global_region_id].reject(&:blank?).each do |global_region|
          @vip_location_global_regions << Vip::LocationGlobalRegion.new({vip_location_id: vip_location_id, vip_global_region_id: global_region})
        end        
      else
        @vip_location_global_region = Vip::LocationGlobalRegion.new(vip_location_global_region_params)
      end	 	    
    end  #  def initialize_vip_location_global_region
	
	  def vip_location_global_region_params
	    params.require(:vip_location_global_region).permit!
	  end
end
