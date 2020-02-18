class ProductSelectorController < ApplicationController

  def index
    @product_families = ProductFamily.parents_with_current_products(website, I18n.locale)
  end

end
