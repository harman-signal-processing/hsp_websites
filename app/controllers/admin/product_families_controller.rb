class Admin::ProductFamiliesController < AdminController
  load_and_authorize_resource
  after_filter :expire_product_families_cache, except: [:index, :show, :new, :edit]

  # GET /admin/product_families
  # GET /admin/product_families.xml
  def index
    @product_families = ProductFamily.all_parents(website)
    @children = (website.product_families - @product_families).sort_by(&:name) 
    if params[:q]
      @searched_product_families = ProductFamily.ransack(params[:q]).result.order(:name)
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_families }
    end
  end

  # GET /admin/product_families/1
  # GET /admin/product_families/1.xml
  def show
    @product_family_product = ProductFamilyProduct.new(product_family: @product_family)
    @locale_product_family = LocaleProductFamily.new(product_family: @product_family)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_family }
    end
  end

  # GET /admin/product_families/new
  # GET /admin/product_families/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_family }
    end
  end

  # GET /admin/product_families/1/edit
  def edit
  end

  # POST /admin/product_families
  # POST /admin/product_families.xml
  def create
    @product_family.brand_id ||= website.brand_id
    respond_to do |format|
      if @product_family.save
        format.html { redirect_to([:admin, @product_family], notice: 'ProductFamily was successfully created.') }
        format.xml  { render xml: @product_family, status: :created, location: @product_family }
        website.add_log(user: current_user, action: "Created product family: #{@product_family.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_family.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PUT /admin/product_families/update_order
  def update_order
    update_list_order(ProductFamily, params["product_family"])
    render nothing: true
    website.add_log(user: current_user, action: "Sorted product families")
  end

  # PUT /admin/product_families/1
  # PUT /admin/product_families/1.xml
  def update
    respond_to do |format|
      if @product_family.update_attributes(params[:product_family])
        format.html { redirect_to([:admin, @product_family], notice: 'ProductFamily was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product family: #{@product_family.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_family.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_families/1
  # DELETE /admin/product_families/1.xml
  def destroy
    @product_family.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_families_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted product family: #{@product_family.name}")
  end

  # Delete custom background
  def delete_background
    @product_family = ProductFamily.find(params[:id])
    @product_family.update_attributes(background_image: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Background was deleted.") }
      format.js 
    end
    website.add_log(user: current_user, action: "Deleted background for family #{@product_family.name}")
  end

  # Delete family photo
  def delete_family_photo
    @product_family = ProductFamily.find(params[:id])
    @product_family.update_attributes(family_photo: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Family photo was deleted.") }
      format.js 
    end
    website.add_log(user: current_user, action: "Deleted family photo from #{@product_family.name}")
  end

  # Delete family banner
  def delete_family_banner
    @product_family = ProductFamily.find(params[:id])
    @product_family.update_attributes(family_banner: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Family banner was deleted.") }
      format.js 
    end
    website.add_log(user: current_user, action: "Deleted family banner image from #{@product_family.name}")
  end

  # Delete title banner
  def delete_title_banner
    @product_family = ProductFamily.find(params[:id])
    @product_family.update_attributes(title_banner: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Title banner was deleted.") }
      format.js 
    end
    website.add_log(user: current_user, action: "Deleted title banner image from #{@product_family.name}")
  end
  
end
