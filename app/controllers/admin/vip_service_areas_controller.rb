class Admin::VipServiceAreasController < AdminController
  load_and_authorize_resource class: "Vip::ServiceArea"
  
  def index
    @vip_service_areas = Vip::ServiceArea.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_service_areas }
      format.json  { render json: @vip_service_areas }
    end    
  end

  def new
  end

  def create
    @vip_service_area = Vip::ServiceArea.new(vip_service_area_params)
    respond_to do |format|
      if @vip_service_area.save

        format.html { redirect_to(admin_vip_service_areas_path, notice: 'AMX VIP Service Area was successfully created.') }
        format.xml  { render xml: @vip_service_area, status: :created, location: @vip_service_area }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip service area #{@vip_service_area.name}")
      else
        format.html { redirect_to(admin_vip_service_areas_path, notice: 'There was a problem creating the AMX VIP Service Area.') }
        format.xml  { render xml: @vip_service_area.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end

  def edit
  end
  
  def update
    @vip_service_area = Vip::ServiceArea.find(params[:id])
    respond_to do |format|
      if @vip_service_area.update_attributes(vip_service_area_params)
        format.html { redirect_to(admin_vip_service_areas_path, notice: 'AMX VIP Service Area was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip service area: #{@vip_service_area.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_service_area.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  # DELETE /vip_service_areas/1
  # DELETE /vip_service_areas/1.xml
  def destroy
    @vip_service_area.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_service_areas_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted an amx vip service area: #{@vip_service_area.name}")
  end    
  
  private
  
    def vip_service_area_params
  	  params.require(:vip_service_area).permit!
    end   
  
end
