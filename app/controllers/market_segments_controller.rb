class MarketSegmentsController < ApplicationController
  before_action :set_locale

  # GET /market_segments
  # GET /market_segments.xml
  def index
    redirect_to product_families_path, status: :moved_permanently
  end

  # GET /market_segments/1
  # GET /market_segments/1.xml
  def show
    @market_segment = MarketSegment.find(params[:id])

    if !website.market_segments.include?(@market_segment)
      redirect_to market_segments_path, status: :moved_permanently and return
    end

    @product_families = @market_segment.market_segment_product_families.map(&:product_family)
    @news = @market_segment.related_news.sort_by(&:post_on).reverse[0,6]

    respond_to do |format|
      format.html { render_template }
      # format.xml  { render xml: @market_segment }
    end
  end
end
