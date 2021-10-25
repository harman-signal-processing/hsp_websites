class Admin::ProductFamiliesController < AdminController
  before_action :initialize_product_family, only: :create
  load_and_authorize_resource

  # GET /admin/product_families
  # GET /admin/product_families.xml
  def index
    @product_families = ProductFamily.all_parents(website)
    @children = ProductFamily.where(brand: website.brand).order(:name) - @product_families
    if params[:q]
      @searched_product_families = ProductFamily.where(brand_id: website.brand_id).ransack(params[:q]).result.order(:name)
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_families }
    end
  end

  # GET /admin/product_families/1
  # GET /admin/product_families/1.xml
  def show
    @product_family_product    = ProductFamilyProduct.new(product_family: @product_family)
    @locale_product_family     = LocaleProductFamily.new(product_family: @product_family)
    @product_family_case_study = ProductFamilyCaseStudy.new(product_family: @product_family)
    @product_family_testimonial = ProductFamilyTestimonial.new(product_family: @product_family)
    @product_family_product_filter = ProductFamilyProductFilter.new(product_family: @product_family)
    @product_family_video = ProductFamilyVideo.new(product_family: @product_family)
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
        format.js
        website.add_log(user: current_user, action: "Created product family: #{@product_family.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_family.errors, status: :unprocessable_entity }
      end
    end
  end

  def copy
    new_product_family = @product_family.copy!
    redirect_to(
      [:admin, new_product_family],
      notice: "The new product family (below) is hidden from navigation. Update that field when you're ready to launch it."
    )
  end

  def copy_products
    if request.post?
      target_family = ProductFamily.find(params[:target_family_id])
      target_family.products += @product_family.products
      target_family.save
      if params[:action_type].to_s.match?(/move/i)
        @product_family.products = []
        @product_family.save
      end
      redirect_to([:admin, target_family], notice: "Products from #{ @product_family.name } have been added below.") and return false
    end
  end

  # PUT /admin/product_families/update_order
  def update_order
    update_list_order(ProductFamily, params["product_family"])
    head :ok
    website.add_log(user: current_user, action: "Sorted product families")
  end

  # PUT /admin/product_families/1
  # PUT /admin/product_families/1.xml
  def update
    respond_to do |format|
      if @product_family.update(product_family_params)
        format.html {
          if params[:return_to]
            return_to = URI.parse(params[:return_to]).path
            redirect_to(return_to, notice: "Product Family was successfully updated.")
          elsif @product_family.brand == website.brand
            redirect_to([:admin, @product_family], notice: 'Product Family was successfully updated.')
          else
            redirect_to( admin_product_families_path, notice: "The family was moved to #{ @product_family.brand.name }. You'll need to manage it on the #{ @product_family.brand.name } admin site.")
          end
        }
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
    @product_family.update(background_image: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Background was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted background for family #{@product_family.name}")
  end

  # Delete family photo
  def delete_family_photo
    @product_family = ProductFamily.find(params[:id])
    @product_family.update(family_photo: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Family photo was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted family photo from #{@product_family.name}")
  end

  # Delete family banner
  def delete_family_banner
    @product_family = ProductFamily.find(params[:id])
    @product_family.update(family_banner: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Family banner was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted family banner image from #{@product_family.name}")
  end

  # Delete title banner
  def delete_title_banner
    @product_family = ProductFamily.find(params[:id])
    @product_family.update(title_banner: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_product_family_path(@product_family), notice: "Title banner was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted title banner image from #{@product_family.name}")
  end

  private

  def initialize_product_family
    @product_family = ProductFamily.new(product_family_params)
  end

  def product_family_params
    params.require(:product_family).permit(
      :name,
      :family_photo,
      :intro,
      :brand_id,
      :keywords,
      :position,
      :parent_id,
      :hide_from_navigation,
      :group_on_custom_shop,
      :background_image,
      :background_color,
      :layout_class,
      :family_banner,
      :title_banner,
      :before_product_content,
      :accessories_content,
      :post_content,
      :short_description,
      :preview_password,
      :preview_username,
      :old_url,
      :has_full_width_features,
      :product_selector_behavior,
      :meta_description,
      :featured_product_id,
      :warranty_period,
      product_family_videos_attributes: {},
      product_family_products_attributes: {}
    )
  end

end
