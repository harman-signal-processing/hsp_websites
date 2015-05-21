collection @brands
attributes :name
node(:id) { |brand|
  brand.friendly_id
}
node(:url) { |brand|
	if brand.live_on_this_platform?
    api_v2_brand_url(brand, format: request.format.to_sym, host: brand.default_website.url).gsub!(/\?.*$/, '')
	else
		nil
	end
}
