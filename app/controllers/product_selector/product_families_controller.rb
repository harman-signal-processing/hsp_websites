class ProductSelector::ProductFamiliesController < ProductSelectorController
  skip_before_action :verify_authenticity_token
  respond_to :html, :js
  caches_action :show

  def show
    @product_family = ProductFamily.find(params[:id])
    @products = @product_family.current_products_plus_child_products(website, check_for_product_selector_exclusions: true, locale: I18n.locale)

    respond_to do |format|
      format.html {
        @product_with_photo = @product_family.first_product_with_photo(website)
      }
      format.js
    end
  end

  def subfamily
    @product_family = ProductFamily.find(params[:subfamily_id])
    @products = @product_family.current_products_plus_child_products(website, check_for_product_selector_exclusions: true, locale: I18n.locale)

    respond_to do |format|
      format.html {
        @parent_family = ProductFamily.find(params[:id])
        @product_with_photo = @product_family.first_product_with_photo(website)
      }
      format.js {
        render action: 'show'
      }
    end
  end

end

