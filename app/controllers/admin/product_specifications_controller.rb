class Admin::ProductSpecificationsController < AdminController
  before_action :load_product, except: [:edit, :update, :create, :update_order, :copy, :destroy]
  before_action :initialize_product_specification, only: :create
  load_and_authorize_resource except: [:index, :copy, :update_order]
  skip_authorization_check only: [:copy, :update_order]

  # GET /admin/product_specifications
  # GET /admin/product_specifications.xml
  def index
    3.times { @product.product_specifications.build }
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_specifications }
    end
  end

  # GET /admin/product_specifications/1
  # GET /admin/product_specifications/1.xml
  def show
    Specification.options_for_select.clear
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_specification }
    end
  end

  # GET /admin/product_specifications/new
  # GET /admin/product_specifications/new.xml
  def new
    @product_specification.product = @product
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_specification }
    end
  end

  # GET /admin/product_specifications/1/edit
  def edit
  end

  # POST /admin/product_specifications
  # POST /admin/product_specifications.xml
  def create
    begin
      specification_params = params.require(:specification).permit(:name)
      specification = Specification.new(specification_params)
      if specification.save
        @product_specification.specification = specification
      elsif specification = Specification.where(name: specification_params[:name]).first
        @product_specification.specification = specification
      end
    rescue
      # probably didn't have a form that can provide a new Specification
    end
    respond_to do |format|
      if @product_specification.save
        format.html { redirect_to(admin_product_product_specifications_path(@product), notice: 'Product specification was successfully created.') }
        format.xml  { render xml: @product_specification, status: :created, location: @product_specification }
        format.js
        website.add_log(user: current_user, action: "Added a #{@product_specification.specification.name} spec to #{@product_specification.product.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_specification.errors, status: :unprocessable_entity }
        format.js { render template: "admin/product_specifications/create_error" }
      end
    end
  end

  # PUT /admin/product_specifications/1
  # PUT /admin/product_specifications/1.xml
  def update
    respond_to do |format|
      if @product_specification.update(product_specification_params)
        format.html { redirect_to(admin_product_product_specifications_path(@product_specification.product), notice: 'Product specification was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated #{@product_specification.specification.name} for #{@product_specification.product.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product/1/products_specifications/bulk_update
  def bulk_update
    product_params = sanitized_product_params
    respond_to do |format|
      if product_params["product_specifications_attributes"].present?
        product_params["product_specifications_attributes"].each do |key, psa|
          if psa.include?("specification_attributes") && psa["specification_attributes"]["name"].present? # creating a new spec
            specification = Specification.where(psa["specification_attributes"]).first_or_create
            psa["specification_id"] = specification.id
            psa.delete("specification_attributes")
          end
        end
      end
      if @product.update(product_params)
        format.html { redirect_to([:admin, @product], notice: 'Product was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product: #{@product.name}")
      else
        format.html { render action: "index" }
        format.xml  { render xml: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_specifications/update_order
  def update_order
    update_list_order(ProductSpecification, params["product_specification"])
    head :ok
    website.add_log(user: current_user, action: "Sorted product specs")
  end

  # Copies ALL the product specs from one to another product
  def copy
    product = Product.find(params[:id])
    product_specification = ProductSpecification.new(product_specification_params)
    product_specification.product.product_specifications.each do |ps|
      new_ps = ps.dup
      new_ps.id = nil # seems dumb to have to do this
      new_ps.product_id = product.id
      new_ps.save
    end
    respond_to do |format|
      format.html { redirect_to [:admin, product], notice: "I've copied what specs I could. Have a look."}
    end
  end

  # DELETE /admin/product_specifications/1
  # DELETE /admin/product_specifications/1.xml
  def destroy
    @product_specification.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_specifications_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted #{@product_specification.specification.name} value from #{@product_specification.product.name}")
  end

  private

  def load_product
    @product = Product.find(params[:product_id])
  end

  def initialize_product_specification
    @product_specification = ProductSpecification.new(product_specification_params)
  end

  def product_specification_params
    params.require(:product_specification).permit(
      :product_id,
      :specification_id,
      :value,
      :position,
      specification_attributes: {},
      specification: []
    )
  end

  def sanitized_product_params
    params.require(:product).permit(
      product_id: [],
      specification_id: [],
      product_specifications_attributes: {}
    )
  end
end
