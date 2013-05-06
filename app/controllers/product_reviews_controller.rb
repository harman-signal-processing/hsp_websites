class ProductReviewsController < ApplicationController
  before_filter :set_locale
  before_filter :ensure_best_url, only: :show
  
  # GET /product_reviews
  # GET /product_reviews.xml
  def index
    @product_reviews = ProductReview.all_for_website(website)

    respond_to do |format|
      format.html { render_template } # index.html.erb
      # format.xml  { render xml: @product_reviews }
    end
  end

  # GET /product_reviews/1
  # GET /product_reviews/1.xml
  def show
    @product_review = ProductReview.find(params[:id])
    if !ProductReview.all_for_website(website).include?(@product_review)
      redirect_to product_reviews_path and return
    end
    if !@product_review.external_link.blank?
      redirect_to @product_review.external_link and return false
    elsif !@product_review.review_file_name.blank?
      redirect_to @product_review.review.url and return false
    end
    respond_to do |format|
      format.html { render_template } # show.html.erb
      # format.xml  { render xml: @product_review }
    end
  end
  
  protected
  
  def ensure_best_url
    @product_review = ProductReview.where(cached_slug: params[:id]).first || ProductReview.find(params[:id])
    # redirect_to @product_review, status: :moved_permanently unless @product_review.friendly_id_status.best?
  end

end
