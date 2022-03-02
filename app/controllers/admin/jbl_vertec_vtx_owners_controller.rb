class Admin::JblVertecVtxOwnersController < AdminController
  load_and_authorize_resource class: "JblVertecVtxOwner"
  
	def index
	    respond_to do |format|
	      format.html {
			    @jbl_vertec_vtx_owner_forms = JblVertecVtxOwner.all.order("created_at DESC")
	      }

	      format.json  {
			    render json: JblVertecVtxOwner.all.order("created_at DESC").as_json()
	      }
	    end	 #  respond_to do |format|

	end  #  def index  
  
  def approve_and_create_dealer
  	id = params[:id]
  	@owner = JblVertecVtxOwner.find(id)
		
		begin
			region = @owner.country == "United States of America" ? "NORTH AMERICA" : nil
			@dealer = Dealer.create(name: @owner.company_name, 
														address: @owner.address, 
														city: @owner.city, 
														state: @owner.state, 
														country: @owner.country,
														zip: @owner.postal_code,
														telephone: @owner.phone,
														email: @owner.email,
														website: @owner.website,
														rental: 1,
														resale: 0,
														service: 0,
														installation: 0,
														account_number: @owner.phone,
														region: region)
														
			website.add_log(user: current_user, action: "Created dealer #{@dealer.name} (#{@dealer.id}) from JblVertecVtxOwner (#{@owner.id})")
			
			@dealer.add_to_brand!(website.brand)													
			brand_dealer_id = @dealer.brand_dealers.first.id
			
			# add rental product associations
	    @owner.rental_products.split(" |--| ").each do |product|
	    	found_product = Product.find_by_name(product)
	    	if found_product.present?
		      BrandDealerRentalProduct.create(brand_dealer_id: brand_dealer_id, product_id: found_product.id)
		      website.add_log(user: current_user, action: "Added rental product #{found_product.name} to #{@dealer.name}")
	    	end 
	    end
			
			@owner.approved = true
			@owner.approved_by = current_user
			@owner.dealer_id = @dealer.id
			@owner.save
			@approved_by = current_user		
		rescue => e
			@error = "Error: #{e.message}"
			website.add_log(user: current_user, action: "An error creating dealer from JblVertecVtxOwner (#{@owner.id}). #{@error}")
		end  #  begin
    
    respond_to do |format|
      format.js
    end     
  end  #  def approve_and_create_dealer
  
end  #  class Admin::JblVertecVtxOwnersController < AdminController
