class Admin::SoftwareTrainingModulesController < AdminController
  before_action :initialize_software_training_module, only: :create
  load_and_authorize_resource
  
  # GET /software_training_modules
  # GET /software_training_modules.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @software_training_modules }
    end
  end

  # GET /software_training_modules/1
  # GET /software_training_modules/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @software_training_module }
    end
  end

  # GET /software_training_modules/new
  # GET /software_training_modules/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @software_training_module }
    end
  end

  # GET /software_training_modules/1/edit
  def edit
  end

  # POST /software_training_modules
  # POST /software_training_modules.xml
  def create
    @called_from = params[:called_from] || 'software'
    respond_to do |format|
      if @software_training_module.save
        format.html { redirect_to([:admin, @software_training_module.training_module], notice: 'Software/training module was successfully created.') }
        format.xml  { render xml: @software_training_module, status: :created, location: @software_training_module }
        format.js
      else
        format.html { render action: "new" }
        format.xml  { render xml: @software_training_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /software_training_modules/1
  # PUT /software_training_modules/1.xml
  def update
    respond_to do |format|
      if @software_training_module.update(software_training_module_params)
        format.html { redirect_to([:admin, @software_training_module.training_module], notice: 'Software/training_module was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @software_training_module.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /admin/software_training_modules/update_order
  def update_order
    update_list_order(SoftwareTrainingModule, params["software_training_module"])
    head :ok
  end

  # DELETE /software_training_modules/1
  # DELETE /software_training_modules/1.xml
  def destroy
    @software_training_module.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @software_training_module.training_module]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_software_training_module
    @software_training_module = SoftwareTrainingModule.new(software_training_module_params)
  end

  def software_training_module_params
    params.require(:software_training_module).permit!
  end
end
