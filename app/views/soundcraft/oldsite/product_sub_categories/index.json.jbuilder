json.array!(@product_sub_categories) do |product_sub_category|
  json.extract! product_sub_category, :id, :name, :description, :live, :orderby
  json.url product_sub_category_url(product_sub_category, format: :json)
end
