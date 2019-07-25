class DistributorsController < ApplicationController
  include Distributors
  
  before_action :set_locale
  # GET /distributors
  # GET /distributors.xml
  def index
    brand = brand_name_to_use_when_getting_distributors
    @country_code = (params[:geo].blank?) ? (session['geo_country'].blank? ? "us" : session['geo_country']) : params[:geo].downcase
    @distributors = get_international_distributors(brand, @country_code)  
    respond_to do |format|
      format.html { render_template }
    end
  end

  # PUT /distributors/search
  def search
    @country = params[:country].blank? ? "United States of America" : params[:country]
    if @country == "USA" || @country == "United States of America"
      redirect_to where_to_buy_path, status: :moved_permanently and return false
    end
    
    @country_code = ISO3166::Country.find_country_by_name(@country).alpha2
    brand = brand_name_to_use_when_getting_distributors
    
    @distributors = get_international_distributors(brand, @country_code)
    respond_to do |format|
      format.html { render_template(action: "index") }
      # format.xml { render xml: @distributors }
    end
  end
  
  # GET /distributors/1
  # GET /distributors/1.xml
  def show
    @distributor = Distributor.find(params[:id])

    respond_to do |format|
      format.html { render_template } # show.html.erb
      # format.xml  { render xml: @distributor }
    end
  end

  def minimal
    @brand = Brand.find(params[:brand_id])
    @country = params[:country].blank? ? "United States of America" : params[:country]   
    @country_code = ISO3166::Country.find_country_by_name(@country).alpha2
    @distributors = get_international_distributors(@brand.name.downcase, @country_code)

    render layout: 'tiny'
  end

  private
  
  # Get the brand name to use when getting distributors from pro site
  def brand_name_to_use_when_getting_distributors
    brand_name = @website.brand.name.downcase
    case brand_name
    when "duran audio"
      brand_name = "axys tunnel by jbl"
    when "audio architect"
      brand_name = "bss"
    else
      brand_name
    end
    
    brand_name
  end  #  def brand_name_to_use_when_getting_distributors

end  #  class DistributorsController < ApplicationController
