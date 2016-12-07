class UsRepsController < ApplicationController
  before_filter :set_locale

	def index
		@us_reps = []
		@us_regions = website.brand.us_regions_for_website
		@us_region = UsRegion.new
    respond_to do |format|
      format.html { render_template }
    end
	end

	def search
    # for search dropdown:
		@us_regions = website.brand.us_regions_for_website
		@us_region = UsRegion.find params[:us_region]
    @us_reps = @us_region.us_rep_regions.where(brand: brand_for_search).collect{|reg| reg.us_rep}.flatten
    respond_to do |format|
      format.html { render_template(action: "index") }
    end
	end

	def show
		@us_rep = UsRep.find(params[:id])
    respond_to do |format|
      format.html { render_template } # show.html.erb
    end
	end

  private

  def brand_for_search
    (website.brand.us_sales_reps_from_brand_id.present?) ?
      Brand.find(website.brand.us_sales_reps_from_brand_id) :
      website.brand
  end

end
