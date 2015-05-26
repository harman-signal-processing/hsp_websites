collection @products
attributes :name

attribute :friendly_id => :id

node(:url) { |product|
  if @brand.live_on_this_platform?
    api_v2_brand_product_url(@brand, product, format: request.format.to_sym, host: @brand.default_website.url).gsub!(/\?.*$/, '')
  else
    # use whatever host the request came in on
    api_v2_brand_product_url(@brand, product, format: request.format.to_sym).gsub!(/\?.*$/, '')
  end
}
