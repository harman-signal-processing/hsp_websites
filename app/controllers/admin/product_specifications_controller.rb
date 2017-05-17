class Admin::ProductSpecificationsController < AdminController
  before_action :initialize_product_specification, only: :create
  load_and_authorize_resource except: [:copy, :update_order]
  skip_authorization_check only: [:copy, :update_order]

  # GET /admin/product_specifications
  # GET /admin/product_specifications.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_specifications }
    end
  end

  # GET /admin/product_specifications/1
  # GET /admin/product_specifications/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_specification }
    end
  end

  # GET /admin/product_specifications/new
  # GET /admin/product_specifications/new.xml
  def new
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
      specification_params = params.require(:specification).permit!
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
        format.html { redirect_to([:admin, @product_specification.product], notice: 'Product specification was successfully created.') }
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
      if @product_specification.update_attributes(product_specification_params)
        format.html { redirect_to([:admin, @product_specification.product], notice: 'Product specification was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated #{@product_specification.specification.name} for #{@product_specification.product.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/product_families/update_order
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

  def initialize_product_specification
    @product_specification = ProductSpecification.new(product_specification_params)
  end

  def product_specification_params
    params.require(:product_specification).permit!
  end
end
