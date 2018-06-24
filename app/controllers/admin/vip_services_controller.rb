class Admin::VipServicesController < AdminController
  load_and_authorize_resource class: "Vip::Service"

  def index
    @vip_services = Vip::Service.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_services }
      format.json  { render json: @vip_services }
    end    
  end

  def show
    @vip_service_categories = Vip::ServiceCategory.all.order(:name)
    @vip_service_service_category = Vip::ServiceServiceCategory.new(vip_service_id: @vip_service.id)
    @vip_service_service_categories = Vip::ServiceServiceCategory.where(vip_service_id: @vip_service.id)    
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_service = Vip::Service.find(params[:id])
    respond_to do |format|
      if @vip_service.update_attributes(vip_service_params)
        format.html { redirect_to(admin_vip_services_path, notice: 'AMX VIP Service was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip service: #{@vip_service.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_service.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_service = Vip::Service.new(vip_service_params)
    respond_to do |format|
      if @vip_service.save

        format.html { redirect_to(admin_vip_services_path, notice: 'AMX VIP Service was successfully created.') }
        format.xml  { render xml: @vip_service, status: :created, location: @vip_service }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip service #{@vip_service.name}")
      else
        format.html { redirect_to(admin_vip_services_path, notice: 'There was a problem creating the AMX VIP Service.') }
        format.xml  { render xml: @vip_service.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_services/1
  # DELETE /vip_services/1.xml
  def destroy
    @vip_service.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_services_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip service: #{@vip_service.name}")
  end   
  
  private
  
    def vip_service_params
  	  params.require(:vip_service).permit!
    end     

end
