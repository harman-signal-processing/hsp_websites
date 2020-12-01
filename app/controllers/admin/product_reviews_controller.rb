class Admin::ProductReviewsController < AdminController
  before_action :initialize_product_review, only: :create
  load_and_authorize_resource

  # GET /admin/product_reviews
  # GET /admin/product_reviews.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_reviews }
    end
  end

  # GET /admin/product_reviews/1
  # GET /admin/product_reviews/1.xml
  def show
    @product_review_product = ProductReviewProduct.new(product_review: @product_review)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_review }
    end
  end

  # GET /admin/product_reviews/new
  # GET /admin/product_reviews/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_review }
    end
  end

  # GET /admin/product_reviews/1/edit
  def edit
  end

  # POST /admin/product_reviews
  # POST /admin/product_reviews.xml
  def create
    respond_to do |format|
      if @product_review.save
        format.html { redirect_to([:admin, @product_review], notice: 'Product Review was successfully created.') }
        format.xml  { render xml: @product_review, status: :created, location: @product_review }
        website.add_log(user: current_user, action: "Created product review: #{@product_review.title}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/product_reviews/1
  # PUT /admin/product_reviews/1.xml
  def update
    respond_to do |format|
      if @product_review.update(product_review_params)
        format.html { redirect_to([:admin, @product_review], notice: 'Product Review was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated product review: #{@product_review.title}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/product_reviews/1
  # DELETE /admin/product_reviews/1.xml
  def destroy
    @product_review.destroy
    respond_to do |format|
      format.html { redirect_to(admin_product_reviews_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted product review: #{@product_review.title}")
  end

  private

  def initialize_product_review
    @product_review = ProductReview.new(product_review_params)
  end

  def product_review_params
    params.require(:product_review).permit(
      :title,
      :external_link,
      :body,
      :review,
      :cover_image
    )
  end
end
