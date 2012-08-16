# The ProductFamilyProduct model is a representation of a join table. So,
# it doesn't really make sense for its REST controller (this controller)
# to have its own set of views. Instead, the methods in this controller
# should be called via AJAX and return Javascript to update whatever view
# sent the method call.
#
# TODO: Create the HTML views just in case.
#
class Admin::ProductFamilyProductsController < AdminController
  load_and_authorize_resource
  after_filter :expire_product_families_cache, only: [:create, :update, :destroy]
    
  # GET /admin/product_family_products
  # GET /admin/product_family_products.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_family_products }
    end
  end

  # GET /admin/product_family_products/1
  # GET /admin/product_family_products/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_family_product }
    end
  end

  # GET /admin/product_family_products/new
  # GET /admin/product_family_products/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_family_product }
    end
  end

  # GET /admin/product_family_products/1/edit
  def edit
  end

  # POST /admin/product_family_products
  # POST /admin/product_family_products.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_family_product.save
        format.html { redirect_to([:admin, @product_family_product], notice: 'Product was successfully added to family.') }
        format.xml  { render xml: @product_family_product, status: :created, location: @product_family_product }
        format.js 
        website.add_log(user: current_user, action: "Added #{@product_family_product.product.name} to #{@product_family_product.product_family.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_family_product.errors, status: :unprocessable_entity }
        format.js { render text: "Error"}
      end
    end
  end

  # PUT /admin/product_family_products/1
  # PUT /admin/product_family_products/1.xml
  def update
    respond_to do |format|
      if @product_family_product.update_attributes(params[:product_family_product])
        format.html { redirect_to([:admin, @product_family_product], notice: 'Product was successfully added to family.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_family_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_family_products/update_order
  def update_order
    update_list_order(ProductFamilyProduct, params["product_family_product"])
    render nothing: true
    website.add_log(user: current_user, action: "Sorted product family products")
  end

  # DELETE /admin/product_family_products/1
  # DELETE /admin/product_family_products/1.xml
  def destroy
    @product_family_product.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_family_products_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed #{@product_family_product.product.name} from #{@product_family_product.product_family.name}")
  end
end
