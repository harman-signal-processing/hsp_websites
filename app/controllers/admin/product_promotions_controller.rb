class Admin::ProductPromotionsController < AdminController
  before_filter :initialize_product_promotion, only: :create
  load_and_authorize_resource
  # GET /product_promotions
  # GET /product_promotions.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_promotions }
    end
  end

  # GET /product_promotions/1
  # GET /product_promotions/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_promotion }
    end
  end

  # GET /product_promotions/new
  # GET /product_promotions/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_promotion }
    end
  end

  # GET /product_promotions/1/edit
  def edit
  end

  # POST /product_promotions
  # POST /product_promotions.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_promotion.save
        format.html { redirect_to([:admin, @product_promotion], notice: 'Product/promotion was successfully created.') }
        format.xml  { render xml: @product_promotion, status: :created, location: @product_promotion }
        format.js
        website.add_log(user: current_user, action: "Added #{@product_promotion.product.name} to #{@product_promotion.promotion.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_promotions/1
  # PUT /product_promotions/1.xml
  def update
    respond_to do |format|
      if @product_promotion.update_attributes(product_promotion_params)
        format.html { redirect_to([:admin, @product_promotion.promotion], notice: 'Product/promotion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_promotion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_promotions/1
  # DELETE /product_promotions/1.xml
  def destroy
    @product_promotion.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_promotion.promotion]) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Removed #{@product_promotion.product.name} from #{@product_promotion.promotion.name}")
  end

  private

  def initialize_product_promotion
    @product_promotion = ProductPromotion.new(product_promotion_params)
  end

  def product_promotion_params
    params.require(:product_promotion).permit!
  end
end
