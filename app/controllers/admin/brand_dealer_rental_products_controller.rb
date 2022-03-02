class Admin::BrandDealerRentalProductsController < AdminController
  load_and_authorize_resource
  
  def create
    brand_dealer_id = brand_dealer_rental_product_params[:brand_dealer_id]
    rental_products = brand_dealer_rental_product_params[:product_id]
    @brand_dealer_rental_products = []
    
    # add rental product associations
    rental_products.map{|product_id|
      @brand_dealer_rental_products << BrandDealerRentalProduct.create(brand_dealer_id: brand_dealer_id, product_id: product_id)
      website.add_log(user: current_user, action: "Added rental product :#{Product.find(product_id).name} to :#{BrandDealer.find(brand_dealer_id).dealer.name}")
    }
    
    respond_to do |format|
      format.js
    end 
  end  #  def create

  def destroy
    @brand_dealer_rental_product.destroy
    respond_to do |format|
      format.js
    end
    website.add_log(user: current_user, action: "Removed rental product :#{@brand_dealer_rental_product.product.name} from :#{@brand_dealer_rental_product.brand_dealer.dealer.name}")
  end  
  
  def update_order
    update_list_order(BrandDealerRentalProduct, params["brand_dealer_rental_product"])
    head :ok
  end  
  
  private
  
  def brand_dealer_rental_product_params
    params.require(:brand_dealer_rental_product).permit(:brand_dealer_id, product_id: [])
  end
  
end  #  class Admin::BrandDealerRentalProductsController < AdminController