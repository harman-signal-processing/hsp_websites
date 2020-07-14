class Admin::VipSkillsController < AdminController
  load_and_authorize_resource class: "Vip::Skill"

  def index
    @vip_skills = Vip::Skill.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_skills }
      format.json  { render json: @vip_skills }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_skill = Vip::Skill.find(params[:id])
    respond_to do |format|
      if @vip_skill.update(vip_skill_params)
        format.html { redirect_to(admin_vip_skills_path, notice: 'AMX VIP Skill was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip skill: #{@vip_skill.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_skill.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_skill = Vip::Skill.new(vip_skill_params)
    respond_to do |format|
      if @vip_skill.save

        format.html { redirect_to(admin_vip_skills_path, notice: 'AMX VIP Skill was successfully created.') }
        format.xml  { render xml: @vip_skill, status: :created, location: @vip_skill }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip skill #{@vip_skill.name}")
      else
        format.html { redirect_to(admin_vip_skills_path, notice: 'There was a problem creating the AMX VIP Skill.') }
        format.xml  { render xml: @vip_skill.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_skills/1
  # DELETE /vip_skills/1.xml
  def destroy
    @vip_skill.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_skills_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip skill: #{@vip_skill.name}")
  end   
  
  private
  
    def vip_skill_params
  	  params.require(:vip_skill).permit!
    end     

end
