class Admin::ProductTrainingClassesController < AdminController
  load_and_authorize_resource
  # GET /product_training_classes
  # GET /product_training_classes.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_training_classes }
    end
  end

  # GET /product_training_classes/1
  # GET /product_training_classes/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_training_class }
    end
  end

  # GET /product_training_classes/new
  # GET /product_training_classes/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_training_class }
    end
  end

  # GET /product_training_classes/1/edit
  def edit
  end

  # POST /product_training_classes
  # POST /product_training_classes.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_training_class.save
        format.html { redirect_to([:admin, @product_training_class.training_class], notice: 'Product/training class was successfully created.') }
        format.xml  { render xml: @product_training_class, status: :created, location: @product_training_class }
        format.js
        website.add_log(user: current_user, action: "Added training class for #{@product_training_class.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_training_class.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_training_classes/1
  # PUT /product_training_classes/1.xml
  def update
    respond_to do |format|
      if @product_training_class.update_attributes(params[:product_training_class])
        format.html { redirect_to([:admin, @product_training_class.training_class], notice: 'Product/training_class was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_training_class.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /admin/product_training_classes/update_order
  def update_order
    update_list_order(ProductTrainingClass, params["product_training_classes"])
    render nothing: true
    website.add_log(user: current_user, action: "Sorted product training classes")
  end

  # DELETE /product_training_classes/1
  # DELETE /product_training_classes/1.xml
  def destroy
    @product_training_class.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_training_class.training_class]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed training class from #{@product_training_class.product.name}")
  end
end
