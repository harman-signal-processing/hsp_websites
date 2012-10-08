object @brand
attributes :id, :name, :friendly_id, :api_banner_url
node(:url) { |brand| brand.default_website.url }

child :product_families do
	attributes :id, :name, :parent_id, :friendly_id
	node(:employee_store_products_count) {|product_family| product_family.employee_store_products.count }
end