xml.instruct! :xml, version: "1.0"

xml.brand name: @brand.name do
  if @brand.logo_file_name.present?
    if S3_STORAGE[:storage] == :filesystem
      xml.logo url: "http://#{request.host}#{@brand.logo.url(:original, timestamp: false)}"
    else
      xml.logo url: @brand.logo.url(:original, timestamp: false)
    end
  end

  xml.software url: api_v2_brand_software_index_url(@brand, format: :xml).gsub!(/\?.*$/, '')
  xml.products url: api_v2_brand_products_url(@brand, format: :xml).gsub!(/\?.*$/, '')

  if @brand.news_feed_url.present?
    xml.rss url: @brand.news_feed_url
  end

  if @brand.default_website
    xml.website url: "http://#{@brand.default_website.url}"
  end
end
