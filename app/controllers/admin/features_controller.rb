class Admin::FeaturesController < AdminController
  before_action :initialize_feature, only: :create
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    if params[:featurable_type].present?
      @feature.featurable_type = params[:featurable_type]
    end

    if params[:featurable_id].present?
      @feature.featurable_id = params[:featurable_id]
    end
  end

  def create
    respond_to do |format|
      if @feature.save
        format.html { redirect_to([:admin, @feature], notice: 'Feature was successfully created.') }
        format.xml  { render xml: @feature, status: :created, location: @feature }
        website.add_log(user: current_user, action: "Created feature: #{@feature.name}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @feature.update(feature_params)
        format.html { redirect_to([:admin, @feature], notice: 'Feature was successfully updated.') }
        format.xml  { head :ok }
        website.add_log(user: current_user, action: "Updated feature: #{@feature.name}")
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feature.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @feature.featurable]) }
      format.xml  { head :ok }
    end
    website.add_log(user: current_user, action: "Deleted feature: #{@feature.name}")
  end

  private

  def initialize_feature
    @feature = Feature.new(feature_params)
  end

  def feature_params
    display_option_flags = [:use_as_banner_slide, :show_below_products, :show_below_videos]
    turn_display_option_flags_off(display_option_flags) # reset because these flags should be mutually exclusive
    params[:feature][:use_as_banner_slide] = 1 if params[:feature][:display_option] == "slide"
    params[:feature][:show_below_products] = 1 if params[:feature][:display_option] == "under_products"
    params[:feature][:show_below_videos] = 1 if params[:feature][:display_option] == "under_videos"
    params.require(:feature).permit(:featurable_type,
      :featurable_id,
      :position,
      :layout_style,
      :content_position,
      :pre_content,
      :content,
      :image,
      :delete_image,
      :video,
      :delete_video,
      :use_as_banner_slide,
      :show_below_products,
      :show_below_videos,
      :display_option)
  end

  def turn_display_option_flags_off(display_option_flags)
    display_option_flags.each { |item| params[:feature][item] = 0 }
  end

end  #  class Admin::FeaturesController < AdminController
