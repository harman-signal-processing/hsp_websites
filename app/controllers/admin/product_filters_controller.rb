class Admin::ProductFiltersController < AdminController
  before_action :initialize_product_filter, only: :create
  load_and_authorize_resource

  # GET /admin/product_filters
  # GET /admin/product_filters.xml
  def index
    @search = ProductFilter.ransack(params[:q])
    @product_filters = @search.result.paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_filter }
    end
  end

  # GET /admin/product_filter/1
  # GET /admin/product_filter/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_filter }
    end
  end

  # GET /admin/product_filter/new
  # GET /admin/product_filter/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_filter }
    end
  end

  # GET /admin/product_filter/1/edit
  def edit
  end

  # POST /admin/product_filter
  # POST /admin/product_filter.xml
  def create
    respond_to do |format|
      if @product_filter.save
        format.html { redirect_to([:admin, @product_filter], notice: 'ProductFilter was successfully created.') }
        format.xml  { render xml: @product_filter, status: :created, location: @product_filter }
        website.add_log(user: current_user, action: "Created product filter: #{@product_filter.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/product_filter/1
  # PUT /admin/product_filter/1.xml
  def update
    respond_to do |format|
      if @product_filter.update_attributes(product_filter_params)
        format.html { redirect_to([:admin, @product_filter], notice: 'ProductFilter was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product filter: #{@product_filter.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_filter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_filter/1
  # DELETE /admin/product_filter/1.xml
  def destroy
    @product_filter.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_filters_index_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted product filter: #{@product_filter.name}")
  end

  private

  def initialize_product_filter
    @product_filter = ProductFilter.new(product_filter_params)
  end

  def product_filter_params
    params.require(:product_filter).permit!
  end
end


