class Admin::ProductPricesController < AdminController
  load_and_authorize_resource
  # GET /admin/product_prices
  # GET /admin/product_prices.xml
  def index
  	@products = website.brand.current_products
  	@pricing_types = website.brand.pricing_types
  	@loc = params[:loc] || "US"
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xls {
        send_data(
          Pricelist.new(website.brand, loc: @loc, website: website, locale: I18n.locale).to_s,
        	filename: "#{website.brand.name}_#{@loc.upcase}_price_list_#{Time.zone.now.year}-#{Time.zone.now.month}-#{Time.zone.now.day}.xls"
        )    
      }
    end
  end

  # GET /admin/product_prices/1
  # GET /admin/product_prices/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
    end
  end

  # GET /admin/product_prices/new
  # GET /admin/product_prices/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
    end
  end

  # GET /admin/product_prices/1/edit
  def edit
  end

  # POST /admin/product_prices
  # POST /admin/product_prices.xml
  def create
    respond_to do |format|
      if @product_price.save
        format.html { redirect_to([:admin, @product_price], notice: 'Pricing was successfully created.') }
        website.add_log(user: current_user, action: "Created pricing: #{@product_price.product.name}")
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /admin/product_prices/1
  # PUT /admin/product_prices/1.xml
  def update
    respond_to do |format|
      if @product_price.update_attributes(params[:product_price])
        format.html { redirect_to([:admin, @product_price], notice: 'Pricing was successfully updated.') }
        website.add_log(user: current_user, action: "Updated pricing: #{@product_price.product.name}")
      else
        format.html { render action: "edit" }
      end
    end
  end

  # Update action for the myharman.com pricing form
  def update_all
    authorize! :manage, ProductPrice
    params[:product_attr].to_a.each do |key, attr|
      product = Product.find(key)
      product.update_attributes(attr)
    end
    redirect_to(admin_product_prices_path, notice: "Pricing updated successfully.")
  end

  # DELETE /admin/product_prices/1
  # DELETE /admin/product_prices/1.xml
  def destroy
    @product_price.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_prices_url) }
    end
    website.add_log(user: current_user, action: "Deleted pricing: #{@product_price.product.name}")
  end
end
