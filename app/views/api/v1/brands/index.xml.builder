xml.instruct! :xml, version: "1.0"
xml.brands do
  @brands.each do |brand|
    if brand.live_on_this_platform?
        xml.brand(brand.name, url: api_v1_brand_url(brand, format: :xml).gsub!(/\?.*$/, ''))
    end
  end
end
