class MarketSegmentsController < ApplicationController
  before_filter :set_locale
  
  # GET /market_segments
  # GET /market_segments.xml
  def index
    redirect_to product_families_path
  end

  # GET /market_segments/1
  # GET /market_segments/1.xml
  def show
    @market_segment = MarketSegment.find(params[:id])
    @product_families = @market_segment.market_segment_product_families.map(&:product_family)
    if !website.market_segments.include?(@market_segment)
      redirect_to market_segments_path and return
    end
    respond_to do |format|
      format.html {
        if @product_families.size == 1
          redirect_to @product_families.first and return 
        end        
      }
      format.xml  { render :xml => @market_segment }
    end
  end
end
