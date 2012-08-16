class Admin::TrainingModulesController < AdminController
  load_and_authorize_resource 
  # GET /admin/training_modules
  # GET /admin/training_modules.xml
  def index
    @training_modules = @training_modules.where(brand_id: website.brand_id).order("UPPER(name)")
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { 
        @training_modules = TrainingModule.all
        render xml: @training_modules 
      }
    end
  end

  # GET /admin/training_modules/1
  # GET /admin/training_modules/1.xml
  def show
    @product_training_module = ProductTrainingModule.new(training_module_id: @training_module.id)
    @software_training_module = SoftwareTrainingModule.new(training_module_id: @training_module.id)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @training_module }
    end
  end

  # GET /admin/training_modules/new
  # GET /admin/training_modules/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @training_module }
    end
  end

  # GET /admin/training_modules/1/edit
  def edit
  end

  # POST /admin/training_modules
  # POST /admin/training_modules.xml
  def create
    @training_module.brand_id = website.brand_id
    respond_to do |format|
      if @training_module.save
        format.html { redirect_to([:admin, @training_module], notice: 'Training module was successfully created.') }
        format.xml  { render xml: @training_module, status: :created, location: @training_module }
        website.add_log(user: current_user, action: "Created training module")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @training_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/training_modules/1
  # PUT /admin/training_modules/1.xml
  def update
    respond_to do |format|
      if @training_module.update_attributes(params[:training_module])
        format.html { redirect_to([:admin, @training_module], notice: 'Training module was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated training module")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @training_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/training_modules/1
  # DELETE /admin/training_modules/1.xml
  def destroy
    @training_module.destroy
    respond_to do |format|
      format.html { redirect_to(admin_training_modules_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted training module")
  end
end
