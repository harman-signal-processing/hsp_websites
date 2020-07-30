class Admin::VipProgrammerTrainingsController < AdminController
	before_action :initialize_vip_programmer_training, only: :create
  load_and_authorize_resource class: "Vip::ProgrammerTraining", except: [:update_order]	
  skip_authorization_check only: [:update_order]
  
  
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
      if @vip_programmer_trainings.present?
        begin
          @vip_programmer_trainings.each do |vip_programmer_training|
            begin
              vip_programmer_training.save!
              website.add_log(user: current_user, action: "Associated #{vip_programmer_training.programmer.name} with #{vip_programmer_training.training.name}")
              format.js
            rescue
              format.js { render template: "admin/vip_programmer_trainings/create_error" }
            end
          end  #  @vip_programmer_trainings.each do |vip_programmer_training|
          
        rescue
          format.js { render template: "admin/vip_programmer_trainings/create_error" }
        end        
      else       
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
    end  #  respond_to do |format|
  end  #  def create  
  
  # PUT /admin/vip_programmer_trainings/1
  # PUT /admin/vip_programmer_trainings/1.xml
  def update
    respond_to do |format|
      if @vip_programmer_training.update(vip_programmer_training_params)
        format.html { redirect_to([:admin, @vip_programmer_training], notice: 'Programmer training was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @vip_programmer_training.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def update_order
    update_list_order(Vip::ProgrammerTraining, params["vip_programmer_training"]) # update_list_order is in application_controller
    head :ok
    website.add_log(user: current_user, action: "Sorted VIP programmer trainings")
  end  
  
  # DELETE /admin/vip_programmer_trainings/1
  # DELETE /admin/vip_programmer_trainings/1.xml
  def destroy
    @called_from = params[:called_from] || "vip_programmer"
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
      if vip_programmer_training_params[:vip_training_id].is_a?(Array)
        @vip_programmer_trainings = []
        vip_programmer_id = vip_programmer_training_params[:vip_programmer_id]
        vip_programmer_training_params[:vip_training_id].reject(&:blank?).each do |training|
          @vip_programmer_trainings << Vip::ProgrammerTraining.new({vip_programmer_id: vip_programmer_id, vip_training_id: training})
        end        
      else
        @vip_programmer_training = Vip::ProgrammerTraining.new(vip_programmer_training_params)
      end	 	    
	  end  #  def initialize_vip_programmer_training
	
	  def vip_programmer_training_params
	    params.require(:vip_programmer_training).permit!
	  end  
end
