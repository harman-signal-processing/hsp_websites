class Admin::ProductTrainingModulesController < AdminController
  before_filter :initialize_product_training_module, only: :create
  load_and_authorize_resource
  
  # GET /product_training_modules
  # GET /product_training_modules.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_training_modules }
    end
  end

  # GET /product_training_modules/1
  # GET /product_training_modules/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_training_module }
    end
  end

  # GET /product_training_modules/new
  # GET /product_training_modules/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_training_module }
    end
  end

  # GET /product_training_modules/1/edit
  def edit
  end

  # POST /product_training_modules
  # POST /product_training_modules.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_training_module.save
        format.html { redirect_to([:admin, @product_training_module.training_module], notice: 'Product/training module was successfully created.') }
        format.xml  { render xml: @product_training_module, status: :created, location: @product_training_module }
        format.js
        website.add_log(user: current_user, action: "Created training module for #{@product_training_module.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_training_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_training_modules/1
  # PUT /product_training_modules/1.xml
  def update
    respond_to do |format|
      if @product_training_module.update_attributes(product_training_module_module)
        format.html { redirect_to([:admin, @product_training_module.training_module], notice: 'Product/training_module was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_training_module.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /admin/product_training_modules/update_order
  def update_order
    update_list_order(ProductTrainingModule, params["product_training_module"])
    render nothing: true
    website.add_log(user: current_user, action: "Sorted product training modules")
  end

  # DELETE /product_training_modules/1
  # DELETE /product_training_modules/1.xml
  def destroy
    @product_training_module.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_training_module.training_module]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed training module from #{@product_training_module.product.name}")
  end

  private

  def initialize_product_training_module
    @product_training_module = ProductTrainingModule.new(product_training_module_params)
  end

  def product_training_module_params
    params.require(:product_training_module).permit!
  end
end
