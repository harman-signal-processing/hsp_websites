class WhereToBuyController < ApplicationController  
  before_filter :set_nav_and_footer_links
  before_filter :geoip
  
  
  def index
    
    #@countries = Country.where(name: @geoip.country_name)
    #@distributors = Distributor.where(country_id: 94)
    @country = Country.new
    @country_dropdown = Country.distinct.select(:name).joins(:distributors).where(distributors: {live: 1}).order(:position, :name)
    
  end
  



end
