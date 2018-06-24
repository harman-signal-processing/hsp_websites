class Admin::VipProgrammerTrainingsController < AdminController
	before_action :initialize_vip_programmer_training, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerTraining"	
  
  
  # GET /admin/vip_programmer_trainings
  # GET /admin/vip_programmer_trainings.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @vip_programmer_training }
    end
  end

  # GET /admin/vip_programmer_trainings/1
  # GET /admin/vip_programmer_trainings/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @vip_programmer_training }
    end
  end   
  
  # GET /admin/vip_programmer_trainings/new
  # GET /admin/vip_programmer_trainings/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @vip_programmer_training }
    end
  end

  # GET /admin/vip_programmer_trainings/1/edit
  def edit
  end  
  
  # POST /admin/vip_programmer_trainings
  # POST /admin/vip_programmer_trainings.xml
  def create
    @called_from = params[:called_from] || "vip_programmer"
    respond_to do |format|
      if @vip_programmer_training.save
        format.html { redirect_to([:admin, @vip_programmer_training], notice: 'Programmer training was successfully created.') }
        format.xml  { render xml: @vip_programmer_training, status: :created, location: @vip_programmer_training }
        format.js 
        website.add_log(user: current_user, action: "Associated a training with #{@vip_programmer_training.programmer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @vip_programmer_training.errors, status: :unprocessable_entity }
        format.js { render template: "admin/vip_programmer_trainings/create_error" }
      end
    end
  end  
  
  # PUT /admin/vip_programmer_trainings/1
  # PUT /admin/vip_programmer_trainings/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_training.update_attributes(vip_programmer_training_params)
        format.html { redirect_to([:admin, @vip_programmer_training], notice: 'Programmer training was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_training.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  # DELETE /admin/vip_programmer_trainings/1
  # DELETE /admin/vip_programmer_trainings/1.xml
  def destroy
    @vip_programmer_training.destroy
    respond_to do |format|
      format.html { redirect_to(admin_vip_programmer_trainings_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a training from #{@vip_programmer_training.programmer.name}")
  end  
  
  private

	  def initialize_vip_programmer_training
	    @vip_programmer_training = Vip::ProgrammerTraining.new(vip_programmer_training_params)
	  end
	
	  def vip_programmer_training_params
	    params.require(:vip_programmer_training).permit!
	  end  
end
