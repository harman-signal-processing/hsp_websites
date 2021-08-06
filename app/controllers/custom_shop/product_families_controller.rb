class CustomShop::ProductFamiliesController < CustomShopController
  before_action :load_product_family, only: :show

  def show
  end

  private

  def load_product_family
    begin
      @product_family = ProductFamily.where(cached_slug: params[:id]).first || ProductFamily.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to custom_shop_path and return
    end
  end

end



