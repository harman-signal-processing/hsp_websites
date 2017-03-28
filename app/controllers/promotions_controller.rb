class PromotionsController < ApplicationController
  before_action :set_locale
  before_action :ensure_best_url, only: :show

  # GET /promotions
  # GET /promotions.xml
  def index
    @current_promotions = Promotion.current_for_website(website)
    @expired_promotions = Promotion.recently_expired_for_website(website)
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
  
  protected
  
  def ensure_best_url
    @promotion = Promotion.where(cached_slug: params[:id]).first || Promotion.find(params[:id])
    # redirect_to @promotion, status: :moved_permanently unless @promotion.friendly_id_status.best?
  end

end
