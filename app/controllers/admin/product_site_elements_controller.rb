class Admin::ProductSiteElementsController < AdminController
  before_filter :initialize_product_site_element, only: :create
  load_and_authorize_resource
  
  # GET /admin/product_site_elements
  # GET /admin/product_site_elements.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_site_elements }
    end
  end

  # GET /admin/product_site_elements/1
  # GET /admin/product_site_elements/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_site_element }
    end
  end

  # GET /admin/product_site_elements/new
  # GET /admin/product_site_elements/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_site_element }
    end
  end

  # GET /admin/product_site_elements/1/edit
  def edit
  end

  # POST /admin/product_site_elements
  # POST /admin/product_site_elements.xml
  def create
    # begin
    #   site_element = SiteElement.new(params[:site_element])
    #   if site_element.save
    #     @product_site_element.site_element = site_element
    #   end
    # rescue
    #   # probably didn't have a form that can provide a new AmpModel
    # end
    @called_from = params[:called_from] || "product"
    respond_to do |format|
      if @product_site_element.save
        format.html { redirect_to([:admin, @product_site_element], notice: 'Product site element was successfully created.') }
        format.xml  { render xml: @product_site_element, status: :created, location: @product_site_element }
        format.js 
        website.add_log(user: current_user, action: "Associated a site element with #{@product_site_element.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_site_element.errors, status: :unprocessable_entity }
        format.js { render template: "admin/product_site_elements/create_error" }
      end
    end
  end

  # PUT /admin/product_site_elements/1
  # PUT /admin/product_site_elements/1.xml
  def update
    respond_to do |format|
      if @product_site_element.update_attributes(product_site_element_params)
        format.html { redirect_to([:admin, @product_site_element], notice: 'Product site element was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_site_element.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_site_elements/1
  # DELETE /admin/product_site_elements/1.xml
  def destroy
    @product_site_element.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_site_elements_url) }
      format.xml  { head :ok }
      format.js 
    end
    website.add_log(user: current_user, action: "Removed a site element from #{@product_site_element.product.name}")
  end

  private

  def initialize_product_site_element
    @product_site_element = ProductSiteElement.new(product_site_element_params)
  end

  def product_site_element_params
    params.require(:product_site_element).permit!
  end
end
