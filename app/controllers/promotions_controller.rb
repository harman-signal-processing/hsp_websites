class PromotionsController < ApplicationController
  before_action :set_locale
  before_action :load_promotion, only: [:show, :edit]

  # GET /promotions
  # GET /promotions.xml
  def index
    @featured_promotion = nil
    @current_promotions = Promotion.current_for_website(website)
    if @current_promotions.length > 0
      promos_with_image = @current_promotions.where("tile_file_name IS NOT NULL")
      if promos_with_image.length > 0
        @featured_promotion = promos_with_image.first
      end
    end
    respond_to do |format|
      format.html { render_template } # index.html.erb
      # format.xml  { render xml: @promotions }
    end
  end

  # GET /promotions/1
  # GET /promotions/1.xml
  def show
    if !(Promotion.all_for_website(website).include?(@promotion) || can?(:manage, @promotion))
      redirect_to promotions_path and return false
    end
    respond_to do |format|
      format.html { render_template } # show.html.erb
      # format.xml  { render xml: @promotion }
    end
  end

  def new
    @promotion = Promotion.new
    authorize! :crete, @promotion
    @promotion.banner = Setting.new
    10.times { @promotion.product_promotions.build }
    @return_to = request.referer
  end

  def edit
    authorize! :update, @promotion
    @promotion.banner ||= Setting.new
    3.times { @promotion.product_promotions.build }
    @return_to = request.referer
  end

  protected

  def load_promotion
    @promotion = Promotion.where(cached_slug: params[:id]).first || Promotion.find(params[:id])
  end

end
