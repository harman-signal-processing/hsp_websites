object @product_family
attributes :id, :name, :friendly_id

child :employee_store_products do
	attributes :id, :name, :friendly_id, :harman_employee_price, :msrp, :sap_sku, :short_description
	node(:thumbnail) { |product|
		if Rails.env.production? || Rails.env.staging?
			if product.photo
 				"http://#{product.brand.default_website.url}#{product.photo.product_attachment.url(:thumb, timestamp: false)}"
 			else
 				"http://#{product.brand.default_website.url}#{image_path('missing-image-22x22.png')}"
 			end
 		else
 			if product.photo
 				"http://#{request.host_with_port}#{product.photo.product_attachment.url(:thumb, timestamp: false)}"
 			else
 				"http://#{request.host_with_port}#{image_path('missing-image-22x22.png')}"
 			end
 		end
	}	

end