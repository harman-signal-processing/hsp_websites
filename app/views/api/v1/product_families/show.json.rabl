object @product_family
attributes :id, :name, :friendly_id

child :employee_store_products do
	extends "api/v1/products/show"
end