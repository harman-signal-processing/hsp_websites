class Admin::BrandSolutionFeaturedProductsController < AdminController
  before_action :load_solution, except: [:index, :update_order]
  before_action :initialize_brand_solution_featured_product, only: :create
  before_action :load_product_options, only: [:new, :edit]
  load_and_authorize_resource

  # GET /admin/brand_solution_featured_products
  # GET /admin/brand_solution_featured_products.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @brand_solution_featured_products }
    end
  end

  # GET /admin/brand_solution_featured_products/1
  # GET /admin/brand_solution_featured_products/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @brand_solution_featured_product }
    end
  end

  # GET /admin/brand_solution_featured_products/new
  # GET /admin/brand_solution_featured_products/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @brand_solution_featured_product }
    end
  end

  # GET /admin/brand_solution_featured_products/1/edit
  def edit
  end

  # POST /admin/brand_solution_featured_products
  # POST /admin/brand_solution_featured_products.xml
  def create
    @called_from = params[:called_from]
    @brand_solution_featured_product.solution = @solution
    @brand_solution_featured_product.brand = website.brand
    respond_to do |format|
      if @brand_solution_featured_product.save
        format.html { redirect_to([:admin, @solution], notice: 'Featured product was successfully created.') }
        format.xml  { render xml: @brand_solution_featured_product, status: :created, location: @brand_solution_featured_product }
        format.js
      else
        format.html { render action: "new" }
        format.xml  { render xml: @brand_solution_featured_product.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /admin/brand_solution_featured_products/1
  # PUT /admin/brand_solution_featured_products/1.xml
  def update
    respond_to do |format|
      if @brand_solution_featured_product.update_attributes(brand_solution_featured_product_params)
        format.html { redirect_to([:admin, @solution], notice: 'Featured product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @brand_solution_featured_product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_order
    update_list_order(BrandSolutionFeaturedProduct, params["brand_solution_featured_product"])
    head :ok
  end

  # DELETE /admin/brand_solution_featured_products/1
  # DELETE /admin/brand_solution_featured_products/1.xml
  def destroy
    @brand_solution_featured_product.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @solution]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_brand_solution_featured_product
    @brand_solution_featured_product = BrandSolutionFeaturedProduct.new(brand_solution_featured_product_params)
  end

  def load_solution
    @solution = Solution.find(params[:solution_id])
  end

  def load_product_options
    @all_products = [[website.brand.name, website.products]]
    Brand.where(live_on_this_platform: true).where.not(id: website.brand_id).order(Arel.sql("UPPER(name)")).each do |brand|
      if Product.where(brand_id: brand.id).count > 0
        @all_products << [brand.name, Product.where(product_status_id: ProductStatus.current_ids, brand_id: brand.id).order("name")]
      end
    end
  end

  def brand_solution_featured_product_params
    params.require(:brand_solution_featured_product).permit!
  end
end
