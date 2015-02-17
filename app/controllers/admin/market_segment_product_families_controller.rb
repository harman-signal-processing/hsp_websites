class Admin::MarketSegmentProductFamiliesController < AdminController
  before_filter :initialize_market_segment_product_family, only: :create
  load_and_authorize_resource

  # GET /admin/market_segment_product_families
  # GET /admin/market_segment_product_families.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @market_segment_product_families }
    end
  end

  # GET /admin/market_segment_product_families/1
  # GET /admin/market_segment_product_families/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @market_segment_product_family }
    end
  end

  # GET /admin/market_segment_product_families/new
  # GET /admin/market_segment_product_families/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @market_segment_product_family }
    end
  end

  # GET /admin/market_segment_product_families/1/edit
  def edit
  end

  # POST /admin/market_segment_product_families
  # POST /admin/market_segment_product_families.xml
  def create
    @called_from = params[:called_from] || "market_segment"
    respond_to do |format|
      if @market_segment_product_family.save
        format.html { redirect_to([:admin, @market_segment_product_family], notice: 'Market segment-product family was successfully created.') }
        format.xml  { render xml: @market_segment_product_family, status: :created, location: @market_segment_product_family }
        format.js
        website.add_log(user: current_user, action: "Created a market segment/product family relationship: #{@market_segment_product_family.market_segment.name} - #{@market_segment_product_family.product_family.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @market_segment_product_family.errors, status: :unprocessable_entity }
        format.js { render template: "admin/market_segments/create_error" }
      end
    end
  end

  # PUT /admin/market_segment_product_families/1
  # PUT /admin/market_segment_product_families/1.xml
  def update
    respond_to do |format|
      if @market_segment_product_family.update_attributes(market_segment_product_family_params)
        format.html { redirect_to([:admin, @market_segment_product_family], notice: 'Market segment-product family was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @market_segment_product_family.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /admin/market_segment_product_families/update_order
  def update_order
    update_list_order(MarketSegmentProductFamily, params["market_segment_product_family"])
    render nothing: true
    website.add_log(user: current_user, action: "Re-ordered market segment/product families")
  end

  # DELETE /admin/market_segment_product_families/1
  # DELETE /admin/market_segment_product_families/1.xml
  def destroy
    @market_segment_product_family.destroy
    respond_to do |format|
      format.html { redirect_to(admin_market_segment_product_families_url) }
      format.xml  { head :ok }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted a market segment/product family relationship: #{@market_segment_product_family.market_segment.name} - #{@market_segment_product_family.product_family.name}")
  end

  private

  def initialize_market_segment_product_family
    @market_segment_product_family = MarketSegmentProductFamily.new(market_segment_product_family_params)
  end

  def market_segment_product_family_params
    params.require(:market_segment_product_family).permit!
  end
end
