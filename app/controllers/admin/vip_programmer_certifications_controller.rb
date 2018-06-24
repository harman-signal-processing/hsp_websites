class Admin::VipProgrammerCertificationsController < AdminController
	before_action :initialize_vip_programmer_certification, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerCertification"	
  
  
  # GET /admin/vip_programmer_certifications
  # GET /admin/vip_programmer_certifications.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_certification }
    end
  end

  # GET /admin/vip_programmer_certifications/1
  # GET /admin/vip_programmer_certifications/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_certification }
    end
  end   
  
  # GET /admin/vip_programmer_certifications/new
  # GET /admin/vip_programmer_certifications/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_certification }
    end
  end

  # GET /admin/vip_programmer_certifications/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_certifications
  # POST /admin/vip_programmer_certifications.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_certification.save
        format.html { redirect_to([:admin, @vip_programmer_certification], notice: 'Programmer certification was successfully created.') }
        format.xml  { render xml: @vip_programmer_certification, status: :created, location: @vip_programmer_certification }
        format.js 
        website.add_log(user: current_user, action: "Associated a certification with #{@vip_programmer_certification.programmer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_programmer_certification.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_programmer_certifications/create_error" }
      end
    end
  end  
  
  # PUT /admin/vip_programmer_certifications/1
  # PUT /admin/vip_programmer_certifications/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_certification.update_attributes(vip_programmer_certification_params)
        format.html { redirect_to([:admin, @vip_programmer_certification], notice: 'Programmer certification was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_certification.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # DELETE /admin/vip_programmer_certifications/1
  # DELETE /admin/vip_programmer_certifications/1.xml
  def destroy
    @vip_programmer_certification.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_certifications_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a certification from #{@vip_programmer_certification.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_certification
	    @vip_programmer_certification = Vip::ProgrammerCertification.new(vip_programmer_certification_params)
	  end
	
	  def vip_programmer_certification_params
	    params.require(:vip_programmer_certification).permit!
	  end  
end
