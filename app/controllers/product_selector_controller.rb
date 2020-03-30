class ProductSelectorController < ApplicationController

  def index
    @product_families = ProductFamily.parents_with_current_products(website, I18n.locale).select do |pf|
      pf unless pf.product_selector_behavior.to_s == "exclude"
    end
  end

end
