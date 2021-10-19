class Admin::ProductFamilyVideosController < AdminController
  before_action :initialize_product_family_video, only: :create
  load_and_authorize_resource
  # GET /product_family_videos
  # GET /product_family_videos.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_family_videos }
    end
  end

  # GET /product_family_videos/1
  # GET /product_family_videos/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_family_video }
    end
  end

  # GET /product_family_videos/new
  # GET /product_family_videos/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_family_video }
    end
  end

  # GET /product_family_videos/1/edit
  def edit
  end

  # POST /product_family_videos
  # POST /product_family_videos.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_family_video.save
        format.html { redirect_to([:admin, @product_family_video.product_family], notice: 'Product/Video was successfully created.') }
        format.xml  { render xml: @product_family_video, status: :created, location: @product_family_video }
        format.js
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_family_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_family_videos/1
  # PUT /product_family_videos/1.xml
  def update
    respond_to do |format|
      if @product_family_video.update(product_family_video_params)
        format.html { redirect_to([:admin, @product_family_video.product_family], notice: 'Product/video was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_family_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_family_videos/1
  # DELETE /product_family_videos/1.xml
  def destroy
    @product_family_video.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_family_video.product_family]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_product_family_video
    @product_family_video = ProductFamilyVideo.new(product_family_video_params)
  end

  def product_family_video_params
    params.require(:product_family_video).permit(
      :product_family_id,
      :youtube_id,
      :position
    )
  end
end

