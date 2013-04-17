object @brand
attributes :id, :name, :friendly_id, :api_banner_url
node(:url) { |brand| 
	if brand.live_on_this_platform?
		brand.default_website.url 
	elsif brand.respond_to?(:external_url)
		brand.external_url
	else
		nil
	end
}
node(:api_banner_url) { |brand|
	if banner = brand.api_banner_url
		if Rails.env.production? || Rails.env.staging?
			if banner.match(/^http/i)
				banner
			elsif brand.live_on_this_platform?
				"http://#{brand.default_website.url}#{banner}"
			else
				nil
			end
		else
			if banner.match(/^http/i)
				banner
			else
				"http://#{request.host_with_port}#{banner}"
			end
		end
	end
}

child :product_families do
	attributes :id, :name, :parent_id, :friendly_id
	node(:employee_store_products_count) {|product_family| product_family.employee_store_products.count }
end

