class Admin::SalesRegionCountriesController < AdminController
  before_action :initialize_sales_region_country, only: :create
  load_and_authorize_resource
  # GET /sales_region_countries
  # GET /sales_region_countries.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @sales_region_countries }
    end
  end

  # GET /sales_region_countries/1
  # GET /sales_region_countries/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @sales_region_country }
    end
  end

  # GET /sales_region_countries/new
  # GET /sales_region_countries/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @sales_region_country }
    end
  end

  # GET /sales_region_countries/1/edit
  def edit
  end

  # POST /sales_region_countries
  # POST /sales_region_countries.xml
  def create
    @called_from = params[:called_from] || 'sales_region'
    respond_to do |format|
      if @sales_region_country.save
        format.html { redirect_to([:admin, @sales_region_country.sales_region], notice: 'SalesRegionCountry was successfully created.') }
        format.xml  { render xml: @sales_region_country, status: :created, location: @sales_region_country }
        format.js
        website.add_log(user: current_user, action: "Associated #{@sales_region_country.name} with #{@sales_region_country.sales_region.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @sales_region_country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sales_region_countries/1
  # PUT /sales_region_countries/1.xml
  def update
    respond_to do |format|
      if @sales_region_country.update(sales_region_country_params)
        format.html { redirect_to([:admin, @sales_region_country.sales_region], notice: 'SalesRegionCountry was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @sales_region_country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_region_countries/1
  # DELETE /sales_region_countries/1.xml
  def destroy
    @sales_region_country.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @sales_region_country.sales_region]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Unassociated #{@sales_region_country.name} with #{@sales_region_country.sales_region.name}")
  end

  private

  def initialize_sales_region_country
    @sales_region_country = SalesRegionCountry.new(sales_region_country_params)
  end

  def sales_region_country_params
    params.require(:sales_region_country).permit!
  end
end

