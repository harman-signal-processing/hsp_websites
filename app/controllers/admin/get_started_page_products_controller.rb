class Admin::GetStartedPageProductsController < AdminController
  before_filter :initialize_get_started_page_product, only: :create
  load_and_authorize_resource

  # GET /admin/get_started_page_products
  # GET /admin/get_started_page_products.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @get_started_page_products }
    end
  end

  # GET /admin/get_started_page_products/1
  # GET /admin/get_started_page_products/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @get_started_page_product }
    end
  end

  # GET /admin/get_started_page_products/new
  # GET /admin/get_started_page_products/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @get_started_page_product }
    end
  end

  # GET /admin/get_started_page_products/1/edit
  def edit
  end

  # POST /admin/get_started_page_products
  # POST /admin/get_started_page_products.xml
  def create
    @called_from = params[:called_from]
    respond_to do |format|
      if @get_started_page_product.save
        format.html { redirect_to([:admin, @get_started_page_product.get_started_page], notice: 'Get Started Page/Product was successfully created.') }
        format.xml  { render xml: @get_started_page_product, status: :created, location: @get_started_page_product }
        format.js
        website.add_log(user: current_user, action: "Added #{@get_started_page_product.product.name} to get started page")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @get_started_page_product.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /admin/get_started_page_products/1
  # PUT /admin/get_started_page_products/1.xml
  def update
    respond_to do |format|
      if @get_started_page_product.update_attributes(get_started_page_product_params)
        format.html { redirect_to([:admin, @get_started_page_product.get_started_page], notice: 'Get Started Page/Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @get_started_page_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/get_started_page_products/1
  # DELETE /admin/get_started_page_products/1.xml
  def destroy
    @get_started_page_product.destroy
    respond_to do |format|
      format.html { redirect_to(admin_get_started_pages_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Unlinked get started page/product #{@get_started_page_product.product.name}, #{@get_started_page_product.get_started_page.name}")
  end

  private

  def initialize_get_started_page_product
    @get_started_page_product = GetStartedPageProduct.new(get_started_page_product_params)
  end

  def get_started_page_product_params
    params.require(:get_started_page_product).permit!
  end
end
