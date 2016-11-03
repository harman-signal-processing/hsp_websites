class Admin::ProductVideosController < AdminController
  before_filter :initialize_product_video, only: :create
  load_and_authorize_resource
  # GET /product_videos
  # GET /product_videos.xml
  def index
    respond_to do |format|
      format.html { render_template } # index.html.erb
      format.xml  { render xml: @product_videos }
    end
  end

  # GET /product_videos/1
  # GET /product_videos/1.xml
  def show
    respond_to do |format|
      format.html { render_template } # show.html.erb
      format.xml  { render xml: @product_video }
    end
  end

  # GET /product_videos/new
  # GET /product_videos/new.xml
  def new
    respond_to do |format|
      format.html { render_template } # new.html.erb
      format.xml  { render xml: @product_video }
    end
  end

  # GET /product_videos/1/edit
  def edit
  end

  # POST /product_videos
  # POST /product_videos.xml
  def create
    @called_from = params[:called_from] || 'product'
    respond_to do |format|
      if @product_video.save
        format.html { redirect_to([:admin, @product_video.product], notice: 'Product/Video was successfully created.') }
        format.xml  { render xml: @product_video, status: :created, location: @product_video }
        format.js
      else
        format.html { render action: "new" }
        format.xml  { render xml: @product_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_videos/1
  # PUT /product_videos/1.xml
  def update
    respond_to do |format|
      if @product_video.update_attributes(product_video_params)
        format.html { redirect_to([:admin, @product_video.product], notice: 'Product/video was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @product_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_videos/1
  # DELETE /product_videos/1.xml
  def destroy
    @product_video.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @product_video.product]) }
      format.xml  { head :ok }
      format.js
    end
  end

  private

  def initialize_product_video
    @product_video = ProductVideo.new(product_video_params)
  end

  def product_video_params
    params.require(:product_video).permit!
  end
end
