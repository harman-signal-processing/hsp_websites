object @product_family
attributes :id, :name, :friendly_id

child :employee_store_products do
	attributes :id, :name, :friendly_id, :harman_employee_price, :msrp, :short_description
	if Rails.env.production? || Rails.env.staging?
	node(:thumbnail) {|product| 
		"http://#{product.brand.default_website.url}#{product.photo.product_attachment.url(:thumb, timestamp: false)}"
	}
	else
	node(:thumbnail) {|product| 
		"http://#{request.host_with_port}#{product.photo.product_attachment.url(:thumb, timestamp: false)}"
	}	
	end
end