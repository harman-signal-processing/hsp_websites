class Admin::ProductsController < AdminController
  load_and_authorize_resource
  skip_authorize_resource only: [:rohs, :update_rohs]
  after_filter :expire_product_families_cache, only: [:create, :update, :destroy]
  
  # GET /admin/products
  # GET /admin/products.xml
  def index
    @search = website.products.ransack(params[:q])
    @products = @search.result
    respond_to do |format|
      format.html { 
        if @products.size == 1
          redirect_to [:admin, @products.first]
        else
          render_template 
        end
      } # index.html.erb
      format.xml  { render xml: @products }
    end
  end

  # GET /admin/products/1
  # GET /admin/products/1.xml
  def show
    @product_family_product = ProductFamilyProduct.new(product: @product)
    @online_retailer_link   = OnlineRetailerLink.new(product: @product)
    @product_attachment     = ProductAttachment.new(product: @product)
    @product_document       = ProductDocument.new(product: @product)
    @product_software       = ProductSoftware.new(product: @product)
    @product_specification  = ProductSpecification.new(product: @product)
    @artist_product         = ArtistProduct.new(product: @product)
    @product_amp_model      = ProductAmpModel.new(product: @product)
    @product_cabinet        = ProductCabinet.new(product: @product)
    @product_effect         = ProductEffect.new(product: @product)
    @product_training_module = ProductTrainingModule.new(product: @product)
    @product_training_class = ProductTrainingClass.new(product: @product)
    @product_suggestion     = ProductSuggestion.new(product: @product)
    @parent_product         = ParentProduct.new(product_id: @product.id)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product }
    end
  end

  # GET /admin/products/new
  # GET /admin/products/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product }
    end
  end

  # GET /admin/products/1/edit
  def edit
  end

  # POST /admin/products
  # POST /admin/products.xml
  def create
    @product.brand = website.brand
    respond_to do |format|
      if @product.save
        format.html { redirect_to([:admin, @product], notice: 'Product was successfully created.') }
        format.xml  { render xml: @product, status: :created, location: @product }
        website.add_log(user: current_user, action: "Created product: #{@product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/products/1
  # PUT /admin/products/1.xml
  def update
    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to([:admin, @product], notice: 'Product was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product: #{@product.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/products/1
  # DELETE /admin/products/1.xml
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to(admin_products_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted product: #{@product.name}")
  end
  
  # Custom method to list all products and their RoHS status
  # GET /admin/products/rohs
  def rohs
    authorize! :update, :rohs
    @products = website.products
    respond_to do |format|
      format.html { render_template } # only have html output for now
    end
  end
  
  # Custom method to update RoHS status for all products at once
  # PUT /admin/products/update_rohs
  def update_rohs
    authorize! :update, :rohs
    rohs_ids = params[:products]
    website.products.each do |product|
      if rohs_ids.include?(product.id.to_s)
        product.update_attributes(rohs: true) unless product.rohs?
      else
        product.update_attributes(rohs: false) if product.rohs?
      end
    end
    respond_to do |format|
      format.html { redirect_to(rohs_admin_products_path, notice: 'RoHS list updated successfully.') }
    end
    website.add_log(user: current_user, action: "Updated ROHS list")
  end
  
  # Delete custom background
  def delete_background
    @product = Product.find(params[:id])
    @product.update_attributes(background_image: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_path(@product), notice: "Background was deleted.") }
      format.js 
    end
    website.add_log(user: current_user, action: "Deleted #{@product.name} custom background")
  end
  
end
