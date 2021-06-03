class CustomShopController < ApplicationController
  include CurrentCustomShopQuote
  before_action :set_locale, :set_custom_shop_quote

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

