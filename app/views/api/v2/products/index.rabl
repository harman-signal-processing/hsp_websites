collection @products
attributes :name

attribute :friendly_id => :id

node(:url) { |product|
  api_v2_brand_product_url(@brand, product, format: request.format.to_sym, host: @brand.default_website.url).gsub!(/\?.*$/, '')
}
