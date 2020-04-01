class ProductSelector::ProductFamiliesController < ProductSelectorController
  skip_before_action :verify_authenticity_token
  respond_to :html, :js
  caches_action :show

  def show
    @product_family = ProductFamily.find(params[:id])
    @products = @product_family.current_products_plus_child_products(website, check_for_product_selector_exclusions: true)

    respond_to do |format|
      format.html { redirect_to @product_family and return false }
      format.js
    end
  end

end

