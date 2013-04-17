class DistributorsController < ApplicationController
  before_filter :set_locale
  # GET /distributors
  # GET /distributors.xml
  def index
    @distributors = []
    @countries = [Distributor.new(country: "USA")] + Distributor.countries(website)
    @country = nil
    respond_to do |format|
      format.html { render_template }
      # format.xml  { 
      #   @distributors = Distributor.all
      #   render xml: @distributors 
      # }
    end
  end
  
  # PUT /distributors/search
  def search
    @country = params[:country]
    if @country == "USA" || @country == "United States of America"
      redirect_to where_to_buy_path and return false
    end
    @distributors = Distributor.find_all_by_country(@country, website)
    @countries = Distributor.countries(website)
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
    @countries = Distributor.countries(@brand)
    @distributors = []
    if params[:country]
      @country = params[:country]
      @distributors = Distributor.find_all_by_country(@country, @brand)
    end
    render layout: 'tiny'
  end

end
