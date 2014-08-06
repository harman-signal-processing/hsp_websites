class Admin::AmpModelsController < AdminController
  before_filter :initialize_amp_model, only: :create
  load_and_authorize_resource

  # GET /amp_models
  # GET /amp_models.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @amp_models }
    end
  end

  # GET /amp_models/1
  # GET /amp_models/1.xml
  def show
    @product_amp_model = ProductAmpModel.new(amp_model: @amp_model)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @amp_model }
    end
  end

  # GET /amp_models/new
  # GET /amp_models/new.xml
  def new
    if params[:product_id]
      @amp_model.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @amp_model }
    end
  end

  # GET /amp_models/1/edit
  def edit
  end

  # POST /amp_models
  # POST /amp_models.xml
  def create
    respond_to do |format|
      if @amp_model.save
        format.html { redirect_to([:admin, @amp_model], notice: 'Amp Model was successfully created.') }
        format.xml  { render xml: @amp_model, status: :created, location: @amp_model }
        website.add_log(user: current_user, action: "Created amp model: #{@amp_model.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @amp_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /amp_models/1
  # PUT /amp_models/1.xml
  def update
    respond_to do |format|
      if @amp_model.update_attributes(amp_model_params)
        format.html { redirect_to([:admin, @amp_model], notice: 'Amp Model was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated amp model: #{@amp_model.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @amp_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /amp_models/1
  # DELETE /amp_models/1.xml
  def destroy
    @amp_model.destroy
    respond_to do |format|
      format.html { redirect_to(admin_amp_models_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted amp model: #{@amp_model.name}")
  end

  private

  def initialize_amp_model
    @amp_model = AmpModel.new(amp_model_params)
  end

  def amp_model_params
    params.require(:amp_model).permit!
  end
end
