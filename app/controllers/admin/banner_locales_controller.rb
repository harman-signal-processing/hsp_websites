class Admin::BannerLocalesController < AdminController
  before_action :load_banner, except: [:update_order]
  before_action :initialize_banner_locale, only: :create
  load_and_authorize_resource except: [:update_order]
  skip_authorization_check only: [:update_order]

  def edit
  end

  def create
    respond_to do |format|
      if @banner_locale.save
        format.html { redirect_to([:admin, @banner, @banner_locale], notice: 'Banner Locale was successfully created.') }
        website.add_log(user: current_user, action: "Created banner locale: #{@banner.name} #{@banner_locale.locale}")
      else
        format.html { render action: "new" }
        format.xml  { render xml: @banner_locale.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @banner_locale.update(banner_locale_params)
        format.html { redirect_to([:admin, @banner, @banner_locale], notice: 'Banner locale was successfully updated.') }
        website.add_log(user: current_user, action: "Updated banner locale: #{@banner.name} #{@banner_locale.locale}")
      else
        format.html { render action: "edit" }
      end
    end
  end

  def update_order
    update_list_order(BannerLocale, params["banner_locale"])
    head :ok
    website.add_log(user: current_user, action: "Sorted banner locales")
  end

  def destroy
    @banner_locale.destroy
    respond_to do |format|
      format.html { redirect_to([:admin, @banner]) }
    end
    website.add_log(user: current_user, action: "Deleted banner locale: #{@banner.name} #{@banner_locale.locale}")
  end

  private

  def initialize_banner_locale
    @banner_locale = BannerLocale.new(banner_locale_params)
    @banner_locale.banner = @banner
  end

  def banner_locale_params
    params.require(:banner_locale).permit(
      :locale,
      :link,
      :title,
      :slide,
      :content,
      :css,
      :position,
      :default
    )
  end

  def load_banner
    @banner = Banner.find params[:banner_id]
  end
end