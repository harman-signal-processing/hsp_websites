collection @product_families
attributes :name

attribute :friendly_id => :id

node(:url) { |product_family|
  if @brand.live_on_this_platform?
    api_v2_brand_product_family_url(@brand, product_family, format: request.format.to_sym, host: @brand.default_website.url).gsub!(/\?.*$/, '')
  else
    # use whatever host the request came in on
    api_v2_brand_product_family_url(@brand, product_family, format: request.format.to_sym).gsub!(/\?.*$/, '')
  end
}

node(:wave) { |product_family|
  wave_api_v2_brand_product_family_url(@brand, product_family, format: 'xls').gsub!(/\?.*$/, '')
}
