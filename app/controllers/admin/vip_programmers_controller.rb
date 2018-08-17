class Admin::VipProgrammersController < AdminController
  before_action :load_logos
  load_and_authorize_resource :class => "Vip::Programmer"
  
  # GET /vip_programmers
  # GET /vip_programmers.xml
  # GET /vip_programmers.json
  def index
      @vip_programmers = Vip::Programmer.all.order(:name)
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render xml: @vip_programmer }
        format.json  { render json: @vip_programmer }
      end
  end

  def new
  end

  def edit
  end

  def show
    @vip_locations = Vip::Location.all.order(:name)
    @vip_programmer_location = Vip::ProgrammerLocation.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_locations = Vip::ProgrammerLocation.where(vip_programmer_id: @vip_programmer.id)
    
    @vip_certifications = Vip::Certification.all.order(:name)
    @vip_programmer_certification = Vip::ProgrammerCertification.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_certifications = Vip::ProgrammerCertification.where(vip_programmer_id: @vip_programmer.id)   
    
    @vip_trainings = Vip::Training.all.order(:name)
    @vip_programmer_training = Vip::ProgrammerTraining.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_trainings = Vip::ProgrammerTraining.where(vip_programmer_id: @vip_programmer.id)  
    
    @vip_services = Vip::Service.all.order(:name)
    @vip_programmer_service = Vip::ProgrammerService.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_services = Vip::ProgrammerService.where(vip_programmer_id: @vip_programmer.id)  
    
    @vip_skills = Vip::Skill.all.order(:name)
    @vip_programmer_skill = Vip::ProgrammerSkill.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_skills = Vip::ProgrammerSkill.where(vip_programmer_id: @vip_programmer.id)   
    
    @vip_markets = Vip::Market.all.order(:name)
    @vip_programmer_market = Vip::ProgrammerMarket.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_markets = Vip::ProgrammerMarket.where(vip_programmer_id: @vip_programmer.id)     
    
    @vip_websites = Vip::Website.all.order(:url)
    @vip_programmer_website = Vip::ProgrammerWebsite.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_websites = Vip::ProgrammerWebsite.where(vip_programmer_id: @vip_programmer.id)
    
    @vip_emails = Vip::Email.all.order(:email)
    @vip_programmer_email = Vip::ProgrammerEmail.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_emails = Vip::ProgrammerEmail.where(vip_programmer_id: @vip_programmer.id) 
    
    @vip_phones = Vip::Phone.all.order(:phone)
    @vip_programmer_phone = Vip::ProgrammerPhone.new(vip_programmer_id: @vip_programmer.id)
    @vip_programmer_phones = Vip::ProgrammerPhone.where(vip_programmer_id: @vip_programmer.id)    
    
  end
  
  def create
    @vip_programmer = Vip::Programmer.new(vip_programmer_params.except(:site_element_ids)) # don't include the :site_element_ids param value when creating @vip_programmer

    respond_to do |format|
      if @vip_programmer.save
        if vip_programmer_params['site_element_ids'].present?
          logo = SiteElement.find(vip_programmer_params['site_element_ids'])
          @vip_programmer.site_elements << logo        
        end
        
        format.html { redirect_to(admin_vip_programmers_path, notice: 'AMX VIP Programmer was successfully created.') }
        format.xml  { render xml: @vip_programmer, status: :created, location: @vip_programmer }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip programmer #{@vip_programmer.name}")
      else
        format.html { redirect_to(admin_vip_programmers_path, notice: 'There was a problem creating the AMX VIP Programmer.') }
        format.xml  { render xml: @vip_programmer.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end    
    
  end
  
  
  # PUT /vip_programmers/1
  # PUT /vip_programmers/1.xml
  def update
    @vip_programmer = Vip::Programmer.find(params[:id])
    respond_to do |format|
      if @vip_programmer.update_attributes(vip_programmer_params)
        format.html { redirect_to(admin_vip_programmers_path, notice: 'AMX VIP Programmer was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip programmer: #{@vip_programmer.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /vip_programmers/1
  # DELETE /vip_programmers/1.xml
  def destroy
    @vip_programmer.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmers_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted an amx vip programmer: #{@vip_programmer.name}")
  end   
  
  private
  
    def vip_programmer_params
  	  params.require(:vip_programmer).permit!
    end  
    
    def load_logos
      @logos = SiteElement.where("name LIKE '%logo_vip_%'").order(:name)
    end
  
end
