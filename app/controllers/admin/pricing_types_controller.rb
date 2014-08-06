class Admin::PricingTypesController < AdminController
  before_filter :initialize_pricing_type, only: :create
  load_and_authorize_resource
  # GET /admin/pricing_types
  # GET /admin/pricing_types.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
    end
  end

  # GET /admin/pricing_types/1
  # GET /admin/pricing_types/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
    end
  end

  # GET /admin/pricing_types/new
  # GET /admin/pricing_types/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
    end
  end

  # GET /admin/pricing_types/1/edit
  def edit
  end

  # POST /admin/pricing_types
  # POST /admin/pricing_types.xml
  def create
  	@pricing_type.brand = website.brand
    respond_to do |format|
      if @pricing_type.save
        format.html { redirect_to(admin_product_prices_path, notice: 'Pricing type was successfully created.') }
        website.add_log(user: current_user, action: "Created pricing type: #{@pricing_type.name}")
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /admin/pricing_types/1
  # PUT /admin/pricing_types/1.xml
  def update
    respond_to do |format|
      if @pricing_type.update_attributes(pricing_type_params)
        format.html { redirect_to(admin_product_prices_path, notice: 'Pricing type was successfully updated.') }
        website.add_log(user: current_user, action: "Updated pricing type: #{@pricing_type.name}")
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /admin/pricing_types/1
  # DELETE /admin/pricing_types/1.xml
  def destroy
    @pricing_type.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_prices_url) }
    end
    website.add_log(user: current_user, action: "Deleted pricing type: #{@pricing_type.name}")
  end

  private

  def initialize_pricing_type
    @pricing_type = PricingType.new(pricing_type_params)
  end

  def pricing_type_params
    params.require(:pricing_type).permit!
  end
end
