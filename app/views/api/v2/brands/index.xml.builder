xml.instruct! :xml, version: "1.0"
xml.brands do
  @brands.each do |brand|
    if brand.live_on_this_platform?
      xml.brand(brand.name, url: api_v2_brand_url(brand, format: :xml, host: brand.default_website.url).gsub!(/\?.*$/, ''))
    end
  end
end
