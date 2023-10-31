class Admin::BannersController < AdminController
  before_action :initialize_banner, only: :create
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
  end

  def new
  end

  def create
    respond_to do |format|
      if @banner.save
        format.html { redirect_to([:admin, @banner], notice: 'Banner was successfully created.') }
        website.add_log(user: current_user, action: "Created banner: #{@banner.name}")
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @banner.update(banner_params)
        format.html { redirect_to([:admin, @banner], notice: 'Banner was successfully updated.') }
        website.add_log(user: current_user, action: "Updated banner: #{@banner.name}")
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    redirect_url = @banner.bannerable_type == "Website" ?
      homepage_admin_settings_path :
      [:admin, @banner.bannerable]
    @banner.destroy
    respond_to do |format|
      format.html { redirect_to(redirect_url) }
      format.js
    end
    website.add_log(user: current_user, action: "Deleted banner: #{@banner.name}")
  end

  private

  def initialize_banner
    @banner = Banner.new(banner_params)
  end

  def banner_params
    params.require(:banner).permit(:name,
      :start_on,
      :remove_on,
      :bannerable_type,
      :bannerable_id
    )
  end
end
