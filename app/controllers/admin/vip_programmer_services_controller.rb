class Admin::VipProgrammerServicesController < AdminController
	before_action :initialize_vip_programmer_service, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerService"	
  
  
  # GET /admin/vip_programmer_services
  # GET /admin/vip_programmer_services.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_service }
    end
  end

  # GET /admin/vip_programmer_services/1
  # GET /admin/vip_programmer_services/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_service }
    end
  end   
  
  # GET /admin/vip_programmer_services/new
  # GET /admin/vip_programmer_services/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_service }
    end
  end

  # GET /admin/vip_programmer_services/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_services
  # POST /admin/vip_programmer_services.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_service.save
        format.html { redirect_to([:admin, @vip_programmer_service], notice: 'Programmer service was successfully created.') }
        format.xml  { render xml: @vip_programmer_service, status: :created, location: @vip_programmer_service }
        format.js 
        website.add_log(user: current_user, action: "Associated a service with #{@vip_programmer_service.programmer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_programmer_service.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_programmer_services/create_error" }
      end
    end
  end  
  
  # PUT /admin/vip_programmer_services/1
  # PUT /admin/vip_programmer_services/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_service.update_attributes(vip_programmer_service_params)
        format.html { redirect_to([:admin, @vip_programmer_service], notice: 'Programmer service was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_service.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # DELETE /admin/vip_programmer_services/1
  # DELETE /admin/vip_programmer_services/1.xml
  def destroy
    @vip_programmer_service.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_services_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a service from #{@vip_programmer_service.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_service
	    @vip_programmer_service = Vip::ProgrammerService.new(vip_programmer_service_params)
	  end
	
	  def vip_programmer_service_params
	    params.require(:vip_programmer_service).permit!
	  end  
end
