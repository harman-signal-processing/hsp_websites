class Admin::VipCertificationsController < AdminController
  load_and_authorize_resource class: "Vip::Certification"
  
  def index
    @vip_certifications = Vip::Certification.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_certifications }
      format.json  { render json: @vip_certifications }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_certification = Vip::Certification.find(params[:id])
    respond_to do |format|
      if @vip_certification.update_attributes(vip_certification_params)
        format.html { redirect_to(admin_vip_certifications_path, notice: 'AMX VIP Certification was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip certification: #{@vip_certification.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_certification.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_certification = Vip::Certification.new(vip_certification_params)
    respond_to do |format|
      if @vip_certification.save

        format.html { redirect_to(admin_vip_certifications_path, notice: 'AMX VIP Certification was successfully created.') }
        format.xml  { render xml: @vip_certification, status: :created, location: @vip_certification }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip certification #{@vip_certification.name}")
      else
        format.html { redirect_to(admin_vip_certifications_path, notice: 'There was a problem creating the AMX VIP Certification.') }
        format.xml  { render xml: @vip_certification.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end  
  
  # DELETE /vip_certifications/1
  # DELETE /vip_certifications/1.xml
  def destroy
    @vip_certification.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_certifications_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip certification: #{@vip_certification.name}")
  end   
  
  private
  
    def vip_certification_params
  	  params.require(:vip_certification).permit!
    end   
end
