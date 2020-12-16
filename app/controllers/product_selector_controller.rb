class ProductSelectorController < ApplicationController
  before_action :set_locale

  def index
    if top_level_families.length == 1
      redirect_to product_selector_product_family_path(top_level_families.first) and return false
    end
  end

  def top_level_families
    @top_level_families ||= ProductFamily.parents_with_current_products(website, I18n.locale).select do |pf|
      pf unless pf.product_selector_behavior.to_s == "exclude"
    end
  end
  helper_method :top_level_families

end
