class ProductSelectorController < ApplicationController
  before_action :load_top_level_families

  def index
  end

private

  def load_top_level_families
    @top_level_families = ProductFamily.parents_with_current_products(website, I18n.locale).select do |pf|
      pf unless pf.product_selector_behavior.to_s == "exclude"
    end
  end

end
