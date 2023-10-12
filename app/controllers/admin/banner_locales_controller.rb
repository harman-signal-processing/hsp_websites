class Admin::BannerLocalesController < AdminController
  before_action :load_banner
  before_action :initialize_banner_locale, only: :create
  load_and_authorize_resource

  def edit
  end

  private

  def initialize_banner_locale
    @banner_locale = BannerLocale.new(banner_locale_params)
  end

  def banner_locale_params
    params.require(:banner_locale).permit(
      :locale,
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