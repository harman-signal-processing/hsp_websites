class Admin::SoftwareTrainingClassesController < AdminController
  before_action :initialize_software_training_class, only: :create
  load_and_authorize_resource
  # GET /software_training_classes
  # GET /software_training_classes.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @software_training_classes }
    end
  end

  # GET /software_training_classes/1
  # GET /software_training_classes/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @software_training_class }
    end
  end

  # GET /software_training_classes/new
  # GET /software_training_classes/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @software_training_class }
    end
  end

  # GET /software_training_classes/1/edit
  def edit
  end

  # POST /software_training_classes
  # POST /software_training_classes.xml
  def create
    @called_from = params[:called_from] || 'software'
    respond_to do |format|
      if @software_training_class.save
        format.html { redirect_to([:admin, @software_training_class.training_class], notice: 'Software/training class was successfully created.') }
        format.xml  { render xml: @software_training_class, status: :created, location: @software_training_class }
        format.js
      else
        format.html { render action: "new" }
        format.xml  { render xml: @software_training_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /software_training_classes/1
  # PUT /software_training_classes/1.xml
  def update
    respond_to do |format|
      if @software_training_class.update(software_training_class_params)
        format.html { redirect_to([:admin, @software_training_class.training_class], notice: 'Software/training_class was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @software_training_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/software_training_classes/update_order
  def update_order
    update_list_order(SoftwareTrainingClass, params["software_training_class"])
    head :ok
  end

  # DELETE /software_training_classes/1
  # DELETE /software_training_classes/1.xml
  def destroy
    @software_training_class.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @software_training_class.training_class]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_software_training_class
    @software_training_class = SoftwareTrainingClass.new(software_training_class_params)
  end

  def software_training_class_params
    params.require(:software_training_class).permit(:software_id, :training_class_id)
  end
end
