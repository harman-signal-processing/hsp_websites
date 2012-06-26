class Admin::ProductAmpModelsController < AdminController
  load_and_authorize_resource
  # GET /admin/product_amp_models
  # GET /admin/product_amp_models.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render :xml => @product_amp_models }
    end
  end

  # GET /admin/product_amp_models/1
  # GET /admin/product_amp_models/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render :xml => @product_amp_model }
    end
  end

  # GET /admin/product_amp_models/new
  # GET /admin/product_amp_models/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render :xml => @product_amp_model }
    end
  end

  # GET /admin/product_amp_models/1/edit
  def edit
  end

  # POST /admin/product_amp_models
  # POST /admin/product_amp_models.xml
  def create
    begin
      amp_model = AmpModel.new(params[:amp_model])
      if amp_model.save
        @product_amp_model.amp_model = amp_model
      end
    rescue
      # probably didn't have a form that can provide a new AmpModel
    end
    @called_from = params[:called_from] || "product"
    respond_to do |format|
      if @product_amp_model.save
        format.html { redirect_to([:admin, @product_amp_model], :notice => 'Product amp_model was successfully created.') }
        format.xml  { render :xml => @product_amp_model, :status => :created, :location => @product_amp_model }
        format.js 
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_amp_model.errors, :status => :unprocessable_entity }
        format.js { render :template => "create_error" }
      end
    end
  end

  # PUT /admin/product_amp_models/1
  # PUT /admin/product_amp_models/1.xml
  def update
    respond_to do |format|
      if @product_amp_model.update_attributes(params[:product_amp_model])
        format.html { redirect_to([:admin, @product_amp_model], :notice => 'Product amp_model was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_amp_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_amp_models/1
  # DELETE /admin/product_amp_models/1.xml
  def destroy
    @product_amp_model.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_amp_models_url) }
      format.xml  { head :ok }
      format.js
    end
  end
end
