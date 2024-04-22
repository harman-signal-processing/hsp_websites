class Admin::ProductFamilyProductsController < AdminController
  before_action :initialize_product_family_product, only: :create
  load_and_authorize_resource except: [:update_order]
  skip_authorization_check only: [:update_order]

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
    #logger.debug ">>>>>>>>>>>>>>>>>> #{ request.content_type }, #{ request.format }, #{ request.method }"
    @called_from = params[:called_from] || 'product'
    respond_to do |format|

      if @product_family_products.present?
        begin
          @product_family_products.each do |product_family_product|
            begin
              product_family_product.save!
              website.add_log(user: current_user, action: "Added #{product_family_product.product.name} to #{product_family_product.product_family.name}")
              format.js
            rescue
              # format.js { render template: "admin/product_family_products/create_error" }
            end
          end

        rescue
          # format.js { render template: "admin/product_family_products/create_error" }
        end

      else

        if @product_family_product.save
          format.html { redirect_to([:admin, @product_family_product], notice: 'Product was successfully added to family.') }
          format.xml  { render xml: @product_family_product, status: :created, location: @product_family_product }
          format.js
          website.add_log(user: current_user, action: "Added #{@product_family_product.product.name} to #{@product_family_product.product_family.name}")
        else
          format.html { render action: "new" }
          format.xml  { render xml: @product_family_product.errors, status: :unprocessable_entity }
          format.js { render plain: "Error"}
        end
      end

    end
  end

  # PUT /admin/product_family_products/1
  # PUT /admin/product_family_products/1.xml
  def update
    respond_to do |format|
      if @product_family_product.update(product_family_product_params)
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
    head :ok
    website.add_log(user: current_user, action: "Sorted product family products")
  end

  # DELETE /admin/product_family_products/1
  # DELETE /admin/product_family_products/1.xml
  def destroy
    @called_from = params[:called_from] || 'product'
    @product_family_product.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_family_products_url) }
      format.xml  { head :ok }
      format.js
    end
    if @product_family_product.product_family.present?
      website.add_log(user: current_user, action: "Removed #{@product_family_product.product.name} from #{@product_family_product.product_family.name}")
    else
      website.add_log(user: current_user, action: "Removed #{@product_family_product.product.name} from deleted family #{@product_family_product.product_family_id}")
    end
  end  #  def destroy

  private

  def initialize_product_family_product
    # will be an array if coming from chosen-rails multiple select dropdown
    if product_family_product_params[:product_id].is_a?(Array)
      @product_family_products = []
      product_family_id = product_family_product_params[:product_family_id]
      product_family_product_params[:product_id].reject(&:blank?).each do |product|
        @product_family_products << ProductFamilyProduct.new({product_family_id: product_family_id, product: Product.find(product)})
      end
    elsif product_family_product_params[:product_family_id].is_a?(Array)
      @product_family_products = []
      product_id = product_family_product_params[:product_id]
      product_family_product_params[:product_family_id].reject(&:blank?).each do |product_family|
        @product_family_products << ProductFamilyProduct.new({product_family_id: product_family, product_id: product_id})
      end
    else
      @product_family_product = ProductFamilyProduct.new(product_family_product_params)
    end
  end

  def product_family_product_params
    params.require(:product_family_product).permit(:product_id, :product_family_id, :position, product_family_id: [], product_id: [])
  end
end
