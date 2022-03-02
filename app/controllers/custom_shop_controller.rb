class CustomShopController < ApplicationController
  if Rails.env.production?
    http_basic_authenticate_with name: ENV['custom_shop_preview_user'], password: ENV['custom_shop_preview_password']
  end

  include CurrentCustomShopCart
  before_action :set_locale

  def index
    @product_families = ProductFamily.customizable(website, I18n.locale)
    render_template
  end

  private

  def load_product
    begin
      @product = Product.where(cached_slug: params[:product_id]).first || Product.find(params[:product_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to search_path(query: params[:product_id].to_s.gsub(/\_|\-/, " ")) and return false
    end
    unless @product.belongs_to_this_brand?(website)
      redirect_to custom_shop_path and return
    end
  end
end

