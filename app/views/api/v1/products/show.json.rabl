object @product
attributes :id, :name, :friendly_id, :harman_employee_price, :msrp, :short_description, :description


if Rails.env.production? || Rails.env.staging?
	node(:thumbnail) {|product| 
		"http://#{product.brand.default_website.url}#{product.photo.product_attachment.url(:thumb, timestamp: false)}"
	}
	node(:photo) {|product|
		"http://#{product.brand.default_website.url}#{product.photo.product_attachment.url(:medium, timestamp: false)}"
	}
else
	node(:thumbnail) {|product| 
		"http://#{request.host_with_port}#{product.photo.product_attachment.url(:thumb, timestamp: false)}"
	}
	node(:photo) {|product| 
		"http://#{request.host_with_port}#{product.photo.product_attachment.url(:medium, timestamp: false)}"
	}	
end

node(:url) {|product|
	product_url(@product, host: @product.brand.default_website.url)
}