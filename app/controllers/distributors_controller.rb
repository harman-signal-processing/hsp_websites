class DistributorsController < ApplicationController
  include Distributors

  before_action :set_locale
  # GET /distributors
  # GET /distributors.xml
  def index
    brand = brand_name_to_use_when_getting_distributors
    @country_code = clean_country_code
    @distributors = get_international_distributors(brand, @country_code)
    respond_to do |format|
      format.html { render_template }
    end
  end

  # PUT /distributors/search
  def search
    @country = params[:country].blank? ? "United States of America" : params[:country]
    if @country == "USA" || @country == "United States of America"
      redirect_to where_to_find_path, status: :moved_permanently and return false
    end

    brand = brand_name_to_use_when_getting_distributors

    respond_to do |format|
      if iso_country = ISO3166::Country.find_country_by_any_name(@country)
        @country_code = iso_country.alpha2
        @distributors = get_international_distributors(brand, @country_code)
        format.html { render_template(action: "index") }
      else
        format.html { redirect_to distributors_path, alert: "No results found." }
      end
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
    @country_code = params[:country].blank? ? "US" : params[:country]
    @country_code = (ISO3166::Country.codes.include? @country_code) ? @country_code : "US"
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
