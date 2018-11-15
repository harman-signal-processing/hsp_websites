class Admin::VipProgrammerCertificationsController < AdminController
	before_action :initialize_vip_programmer_certification, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerCertification", except: [:update_order]	
  skip_authorization_check only: [:update_order]
  
  
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
      if @vip_programmer_certifications.present?
        begin
          @vip_programmer_certifications.each do |vip_programmer_certification|
            begin
              vip_programmer_certification.save!
              website.add_log(user: current_user, action: "Associated #{vip_programmer_certification.programmer.name} with #{vip_programmer_certification.certification.name}")
              format.js
            rescue
              format.js { render template: "admin/vip_programmer_certifications/create_error" }
            end
          end  #  @vip_programmer_certifications.each do |vip_programmer_certification|
          
        rescue
          format.js { render template: "admin/vip_programmer_certifications/create_error" }
        end        
      else       
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
    end  #  respond_to do |format|
  end  #  def create
  
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
  
  def update_order
    update_list_order(Vip::ProgrammerCertification, params["vip_programmer_certification"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted VIP programmer certifications")
  end  
  
  # DELETE /admin/vip_programmer_certifications/1
  # DELETE /admin/vip_programmer_certifications/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_programmer"
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
      if vip_programmer_certification_params[:vip_certification_id].is_a?(Array)
        @vip_programmer_certifications = []
        vip_programmer_id = vip_programmer_certification_params[:vip_programmer_id]
        vip_programmer_certification_params[:vip_certification_id].reject(&:blank?).each do |certification|
          @vip_programmer_certifications << Vip::ProgrammerCertification.new({vip_programmer_id: vip_programmer_id, vip_certification_id: certification})
        end        
      else
        @vip_programmer_certification = Vip::ProgrammerCertification.new(vip_programmer_certification_params)
      end	 	    
	  end  #  def initialize_vip_programmer_certification
	
	  def vip_programmer_certification_params
	    params.require(:vip_programmer_certification).permit!
	  end  
end
