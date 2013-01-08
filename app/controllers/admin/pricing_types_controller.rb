class Admin::PricingTypesController < AdminController
  load_and_authorize_resource
  # GET /admin/pricing_types
  # GET /admin/pricing_types.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xls {
        send_data(website.brand.current_products.to_xls(
          header_format: {weight: :bold},
          headers: %w[Product Description MSRP MAP] + @pricing_types.where("pricelist_order > 0").pluck(:name),
          columns: [:name, :short_description, :msrp, :street_price]),
          filename: "#{website.brand.name}_price_list_#{Time.zone.now.year}-#{Time.zone.now.month}-#{Time.zone.now.day}.xls"
        )        
      }
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
        format.html { redirect_to([:admin, @pricing_type], notice: 'Pricing type was successfully created.') }
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
      if @pricing_type.update_attributes(params[:pricing_type])
        format.html { redirect_to([:admin, @pricing_type], notice: 'Pricing type was successfully updated.') }
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
      format.html { redirect_to(admin_pricing_types_url) }
    end
    website.add_log(user: current_user, action: "Deleted pricingtype: #{@pricing_type.name}")
  end
end
