class Admin::VipProgrammerSkillsController < AdminController
	before_action :initialize_vip_programmer_skill, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerSkill", except: [:update_order]
  skip_authorization_check only: [:update_order]
  
  
  # GET /admin/vip_programmer_skills
  # GET /admin/vip_programmer_skills.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_skill }
    end
  end

  # GET /admin/vip_programmer_skills/1
  # GET /admin/vip_programmer_skills/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_skill }
    end
  end   
  
  # GET /admin/vip_programmer_skills/new
  # GET /admin/vip_programmer_skills/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_skill }
    end
  end

  # GET /admin/vip_programmer_skills/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_skills
  # POST /admin/vip_programmer_skills.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_skill.save
        format.html { redirect_to([:admin, @vip_programmer_skill], notice: 'Programmer skill was successfully created.') }
        format.xml  { render xml: @vip_programmer_skill, status: :created, location: @vip_programmer_skill }
        format.js 
        website.add_log(user: current_user, action: "Associated a skill with #{@vip_programmer_skill.programmer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_programmer_skill.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_programmer_skills/create_error" }
      end
    end
  end  
  
  # PUT /admin/vip_programmer_skills/1
  # PUT /admin/vip_programmer_skills/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_skill.update_attributes(vip_programmer_skill_params)
        format.html { redirect_to([:admin, @vip_programmer_skill], notice: 'Programmer skill was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_skill.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def update_order
    update_list_order(Vip::ProgrammerSkill, params["vip_programmer_skill"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted VIP programmer skills")
  end  
  
  # DELETE /admin/vip_programmer_skills/1
  # DELETE /admin/vip_programmer_skills/1.xml
  def destroy
    @vip_programmer_skill.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_skills_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a skill from #{@vip_programmer_skill.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_skill
	    @vip_programmer_skill = Vip::ProgrammerSkill.new(vip_programmer_skill_params)
	  end
	
	  def vip_programmer_skill_params
	    params.require(:vip_programmer_skill).permit!
	  end  
end
