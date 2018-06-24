class Admin::VipTrainingsController < AdminController
  load_and_authorize_resource class: "Vip::Training"

  def index
    @vip_trainings = Vip::Training.all.order(:name)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @vip_trainings }
      format.json  { render json: @vip_trainings }
    end    
  end

  def show
  end

  def new
  end

  def edit
  end
  
  def update
    @vip_training = Vip::Training.find(params[:id])
    respond_to do |format|
      if @vip_training.update_attributes(vip_training_params)
        format.html { redirect_to(admin_vip_trainings_path, notice: 'AMX VIP Training was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated a amx vip training: #{@vip_training.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_training.errors, status: :unprocessable_entity }
      end
    end 
  end  
  
  def create
    @vip_training = Vip::Training.new(vip_training_params)
    respond_to do |format|
      if @vip_training.save

        format.html { redirect_to(admin_vip_trainings_path, notice: 'AMX VIP Training was successfully created.') }
        format.xml  { render xml: @vip_training, status: :created, location: @vip_training }
        format.js # Not really applicable because the attachment can't be sent via AJAX
        website.add_log(user: current_user, action: "Created amx vip training #{@vip_training.name}")
      else
        format.html { redirect_to(admin_vip_trainings_path, notice: 'There was a problem creating the AMX VIP Training.') }
        format.xml  { render xml: @vip_training.errors, status: :unprocessable_entity }
        format.js { render plain: "Error" }
      end
    end      
  end    
  
  # DELETE /vip_trainings/1
  # DELETE /vip_trainings/1.xml
  def destroy
    @vip_training.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_trainings_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted a amx vip training: #{@vip_training.name}")
  end   
  
  private
  
    def vip_training_params
  	  params.require(:vip_training).permit!
    end     

end
