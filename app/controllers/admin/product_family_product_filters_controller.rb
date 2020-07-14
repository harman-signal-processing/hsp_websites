class Admin::ProductFamilyProductFiltersController < AdminController
  before_action :initialize_product_family_product_filter, only: :create
  load_and_authorize_resource

  # GET /admin/product_family_product_filters
  # GET /admin/product_family_product_filters.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_family_product_filters }
    end
  end

  # GET /admin/product_family_product_filters/1
  # GET /admin/product_family_product_filters/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_family_product_filter }
    end
  end

  # GET /admin/product_family_product_filters/new
  # GET /admin/product_family_product_filters/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_family_product_filter }
    end
  end

  # GET /admin/product_family_product_filters/1/edit
  def edit
  end

  # POST /admin/product_family_product_filters
  # POST /admin/product_family_product_filters.xml
  def create
    @called_from = params[:called_from] || 'product_family'
    respond_to do |format|
      if @product_family_product_filter.save
        format.html { redirect_to([:admin, @product_family_product_filter.product_family], notice: 'Product Filter was successfully added to family.') }
        format.xml  { render xml: @product_family_product_filter, status: :created, location: @product_family_product_filter }
        format.js
        website.add_log(user: current_user, action: "Added #{@product_family_product_filter.product_filter.name} to #{@product_family_product_filter.product_family.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_family_product_filter.errors, status: :unprocessable_entity }
        format.js { render plain: "Error"}
      end
    end
  end

  # PUT /admin/product_family_product_filters/1
  # PUT /admin/product_family_product_filters/1.xml
  def update
    respond_to do |format|
      if @product_family_product_filter.update(product_family_product_filter_params)
        format.html { redirect_to([:admin, @product_family_product_filter], notice: 'Update successful') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_family_product_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_family_product_filters/update_order
  def update_order
    update_list_order(ProductFamilyProductFilter, params["product_family_product_filter"])
    head :ok
    website.add_log(user: current_user, action: "Sorted product family product filters")
  end


  # DELETE /admin/product_family_product_filters/1
  # DELETE /admin/product_family_product_filters/1.xml
  def destroy
    @called_from = params[:called_from] || 'product_family'
    @product_family_product_filter.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_filters_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed #{@product_family_product_filter.product_filter.name} from #{@product_family_product_filter.product_family.name}")
  end

  private

  def initialize_product_family_product_filter
    @product_family_product_filter = ProductFamilyProductFilter.new(product_family_product_filter_params)
  end

  def product_family_product_filter_params
    params.require(:product_family_product_filter).permit!
  end
end

