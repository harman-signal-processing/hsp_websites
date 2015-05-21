object @brand
attributes :name

node(:id) { |brand|
  brand.friendly_id
}

node(:software) { |brand|
  api_v2_brand_software_index_url(brand, format: request.format.to_sym).gsub!(/\?.*$/, '')
}

node(:products) { |brand|
  api_v2_brand_products_url(brand, format: request.format.to_sym).gsub!(/\?.*$/, '')
}

if @brand.logo_file_name.present?
  node(:logo) { |brand|
    if S3_STORAGE[:storage] == :filesystem
      "http://#{request.host}#{brand.logo.url(:original, timestamp: false)}"
    else
      brand.logo.url(:original, timestamp: false)
    end
  }
end

node(:rss) { |brand|
  brand.news_feed_url
}

node(:website) { |brand|
	if brand.live_on_this_platform?
		"http://#{brand.default_website.url}"
	elsif brand.respond_to?(:external_url)
		brand.external_url
	else
		nil
	end
}

