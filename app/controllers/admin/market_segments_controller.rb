class Admin::MarketSegmentsController < AdminController
  before_action :initialize_market_segment, only: :create
  load_and_authorize_resource
  # GET /admin/market_segments
  # GET /admin/market_segments.xml
  def index
    @market_segments = MarketSegment.all_parents(website)
    @children = (website.market_segments - @market_segments).sort_by(&:name)
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @market_segments }
    end
  end

  # GET /admin/market_segments/1
  # GET /admin/market_segments/1.xml
  def show
    @market_segment_product_family = MarketSegmentProductFamily.new(market_segment: @market_segment)
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @market_segment }
    end
  end

  # GET /admin/market_segments/new
  # GET /admin/market_segments/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @market_segment }
    end
  end

  # GET /admin/market_segments/1/edit
  def edit
  end

  # POST /admin/market_segments
  # POST /admin/market_segments.xml
  def create
    @market_segment.brand = website.brand
    respond_to do |format|
      if @market_segment.save
        format.html { redirect_to([:admin, @market_segment], notice: 'Market Segment was successfully created.') }
        format.xml  { render xml: @market_segment, status: :created, location: @market_segment }
        website.add_log(user: current_user, action: "Created a market segment: #{@market_segment.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @market_segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /admin/market_segments/update_order
  def update_order
    update_list_order(MarketSegment, params["market_segment"])
    head :ok
    website.add_log(user: current_user, action: "Sorted market segments")
  end

  # PUT /admin/market_segments/1
  # PUT /admin/market_segments/1.xml
  def update
    respond_to do |format|
      if @market_segment.update(market_segment_params)
        format.html { redirect_to([:admin, @market_segment], notice: 'Market Segment was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated market segment #{@market_segment.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @market_segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # Delete banner
  def delete_banner_image
    @market_segment = MarketSegment.find(params[:id])
    @market_segment.update(banner_image: nil)
    respond_to do |format|
      format.html { redirect_to(edit_admin_market_segment_path(@market_segment), notice: "Banner was deleted.") }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted banner image from market segment: #{@market_segment.name}")
  end

  # DELETE /admin/market_segments/1
  # DELETE /admin/market_segments/1.xml
  def destroy
    @market_segment.destroy
    respond_to do |format|
      format.html { redirect_to(admin_market_segments_url) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted market segment #{@market_segment.name}")
  end

  private

  def initialize_market_segment
    @market_segment = MarketSegment.new(market_segment_params)
  end

  def market_segment_params
    params.require(:market_segment).permit(
      :name,
      :brand_id,
      :banner_image_file_name,
      :parent_id,
      :position,
      :description,
      :banner_image,
      :hide_page_title,
      :custom_css,
      :custom_js
    )
  end
end
