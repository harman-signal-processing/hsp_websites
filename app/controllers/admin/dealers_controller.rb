class Admin::DealersController < AdminController
  before_action :initialize_dealer, only: :create
  load_and_authorize_resource
  # GET /admin/dealers
  # GET /admin/dealers.xml
  def index
    @this_brand = !!(params[:this_brand].to_i > 0)
    @search = (@this_brand) ? website.brand.dealers.ransack(params[:q]) : Dealer.ransack(params[:q])
    if params[:q]
      @dealers = @search.result
    else
      @dealers = []
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @dealers }
    end
  end

  # GET /admin/dealers/1
  # GET /admin/dealers/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @dealer }
    end
  end

  # GET /admin/dealers/new
  # GET /admin/dealers/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @dealer }
    end
  end

  # GET /admin/dealers/1/edit
  def edit
  end

  # POST /admin/dealers
  # POST /admin/dealers.xml
  def create
    @dealer.skip_sync_from_sap = true
    respond_to do |format|
      if @dealer.save
        BrandDealer.create(brand_id: website.brand_id, dealer_id: @dealer.id)
        format.html { redirect_to([:admin, @dealer], notice: 'Dealer was successfully created.') }
        format.xml  { render xml: @dealer, status: :created, location: @dealer }
        website.add_log(user: current_user, action: "Created dealer #{@dealer.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @dealer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/dealers/1
  # PUT /admin/dealers/1.xml
  def update
    @dealer.skip_sync_from_sap = true
    dealer_params_without_products = dealer_params
    dealer_params_without_products.extract!(:products)
    respond_to do |format|
      if @dealer.update(dealer_params_without_products)
        format.html { redirect_to([:admin, @dealer], notice: 'Dealer was successfully updated.') }
        format.xml  { head :ok }
        format.js
        website.add_log(user: current_user, action: "Updated dealer #{@dealer.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @dealer.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  # DELETE /admin/dealers/1
  # DELETE /admin/dealers/1.xml
  def destroy
    @dealer.destroy
    respond_to do |format|
      format.html { redirect_to(admin_dealers_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted dealer #{@dealer.name}")
  end

  def export_dealer_list
    dealers = website.brand.dealers
            .where.not(exclude: 1)
            .or(website.brand.dealers.where(exclude: nil))
            .sort_by{|item| [item.region, item.country, item.name] }
    if website.brand.name == "JBL Professional"
      # get products slug list
      if website.value_for("jblpro-dealer-list-product-slugs").present?
         product_slugs_to_use_as_column_headers = website.value_for("jblpro-dealer-list-product-slugs").gsub(/\s+/, "") .split(",")
         discontinued_product_slugs = website.value_for("jblpro-dealer-list-discontinued-product-slugs").gsub(/\s+/, "") .split(",")
      end
    end  #  if website.brand.name == "JBL Professional"

    respond_to do |format|
      format.xls {
        report_data = Dealer.simple_report_for_admin(
          website.brand, {
            format: 'xls'
          }, dealers, product_slugs_to_use_as_column_headers, discontinued_product_slugs
        )
        send_data(report_data,
          filename: "#{website.brand.name}_dealers_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end  #  respond_to do |format|

  end  #  def export_dealer_list

  def export_dealer_list_by_type
    dealers = website.brand.dealers
            .where.not(exclude: 1)
            .or(website.brand.dealers.where(exclude: nil))
            .sort_by{|item| [item.region, item.country, item.name] }

    respond_to do |format|
      format.xls {
        report_data = Dealer.simple_report_for_admin_by_type(
          website.brand, {
            format: 'xls'
          }, dealers
        )
        send_data(report_data,
          filename: "#{website.brand.name}_dealers_by_type_#{I18n.l Date.today}.xls",
          type: "application/excel; charset=utf-8; header=present"
        )
      }
    end  #  respond_to do |format|

  end  #  def export_dealer_list_by_type

  private

  def initialize_dealer
    @dealer = Dealer.new(dealer_params)
  end

  def dealer_params
    params.require(:dealer).permit(
      :name,
      :name2,
      :name3,
      :name4,
      :address,
      :city,
      :state,
      :zip,
      :telephone,
      :fax,
      :email,
      :account_number,
      :lat,
      :lng,
      :exclude,
      :skip_sync_from_sap,
      :website,
      :google_map_place_id,
      :country,
      :resale,
      :rush,
      :rental,
      :installation,
      :represented_in_country,
      :service,
      :products,
      :region,
      products: [],
      brand_ids: []
    )
  end

  def jblpro_dealer_export_product_slugs
  end  #  def jblpro_dealer_export_product_slugs
end  #  class Admin::DealersController < AdminController
