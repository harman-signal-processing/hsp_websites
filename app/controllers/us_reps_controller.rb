class UsRepsController < ApplicationController
  before_action :set_locale

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

	def us_reps_json
	    respond_to do |format|
	      format.html { render plain: "This method is designed as an json call only. Please add '.json' to your request."}
	      format.json  { render json: get_reps }
	    end
	end

  private

	def get_reps
		rep_json = JSON.parse(website.brand.us_reps.joins(:us_rep_regions).joins(:us_regions).distinct.to_json(
			except: [:cached_slug,:created_at,:updated_at],
		  include: { us_regions:{ only:[:name] } }))

		rep_json.each do |rep|
		  # remove duplicate region names and sort
		  rep["us_regions"] = rep["us_regions"].uniq.map{|region| region["name"]}.sort
		end

		rep_json
	end  #  get_reps

  def brand_for_search
    (website.brand.us_sales_reps_from_brand_id.present?) ?
      Brand.find(website.brand.us_sales_reps_from_brand_id) :
      website.brand
  end

end
