class Admin::VipGlobalRegionsController < AdminController
  load_and_authorize_resource class: "Vip::GlobalRegion"
  
  def index
    @vip_global_regions = Vip::GlobalRegion.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_locations }
      format.json  { render json: @vip_locations }
    end    
  end

  def edit
  end

  def update
    @vip_global_region = Vip::GlobalRegion.find(params[:id])
    respond_to do |format|
      if @vip_global_region.update_attributes(vip_global_region_params)
        format.html { redirect_to(admin_vip_global_regions_path, notice: 'AMX VIP Global Region was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip global region: #{@vip_global_region.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_global_region.errors, status: :unprocessable_entity }
      end
    end 
  end

  def new
  end
  
  def create
    @vip_global_region = Vip::GlobalRegion.new(vip_global_region_params)
    respond_to do |format|
      if @vip_global_region.save

        format.html { redirect_to(admin_vip_global_regions_path, notice: 'AMX VIP Global Region was successfully created.') }
        format.xml  { render xml: @vip_global_region, status: :created, location: @vip_global_region }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip global region #{@vip_global_region.name}")
      else
        format.html { redirect_to(admin_vip_global_regions_path, notice: 'There was a problem creating the AMX VIP Global Region.') }
        format.xml  { render xml: @vip_global_region.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end
  
  # DELETE /vip_global_regions/1
  # DELETE /vip_global_regions/1.xml
  def destroy
    @vip_global_region.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_global_regions_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted an amx vip global region: #{@vip_global_region.name}")
  end   
  
  
  private
  
    def vip_global_region_params
  	  params.require(:vip_global_region).permit!
    end 
  
end
