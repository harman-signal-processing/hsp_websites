class Admin::ProductIntroductionsController < AdminController
  load_and_authorize_resource
  # GET /product_introductions
  # GET /product_introductions.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_introductions }
    end
  end

  # GET /product_introductions/1
  # GET /product_introductions/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_introduction }
    end
  end

  # GET /product_introductions/new
  # GET /product_introductions/new.xml
  def new
    if params[:product_id]
      @product_introduction.product = Product.find(params[:product_id])
    end
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_introduction }
    end
  end

  # GET /product_introductions/1/edit
  def edit
  end

  # POST /product_introductions
  # POST /product_introductions.xml
  def create
    respond_to do |format|
      if @product_introduction.save
        format.html { redirect_to([:admin, @product_introduction.product], notice: 'Product Introduction was successfully created.') }
        format.xml  { render xml: @product_introduction, status: :created, location: @product_introduction }
        website.add_log(user: current_user, action: "Created Product Introduction: #{@product_introduction.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_introduction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_introductions/1
  # PUT /product_introductions/1.xml
  def update
    respond_to do |format|
      if @product_introduction.update_attributes(params[:product_introduction])
        format.html { redirect_to([:admin, @product_introduction.product], notice: 'Product Introduction was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated Product Introduction: #{@product_introduction.product.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_introduction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_introductions/1
  # DELETE /product_introductions/1.xml
  def destroy
    @product_introduction.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_introduction.product], notice: 'Product Introduction was deleted.') }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted Product Introduction: #{@product_introduction.product.name}")
  end
end