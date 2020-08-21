object @brand
attributes :name

attribute :friendly_id => :id
attribute :news_feed_url => :rss

node(:software) { |brand| api_v2_brand_software_index_url(brand, format: request.format.to_sym).gsub!(/\?.*$/, '') }
node(:products) { |brand| api_v2_brand_products_url(brand, format: request.format.to_sym).gsub!(/\?.*$/, '') }
node(:product_families) { |brand| api_v2_brand_product_families_url(brand, format: request.format.to_sym).gsub!(/\?.*$/, '') }

if @brand.logo_file_name.present?
  @brand.logo.styles.each do |logo|
    node("logo_#{logo.first}".to_sym) do |s|
      if S3_STORAGE[:storage] == :filesystem
        "#{request.protocol}#{request.host}#{@brand.logo.url(logo.first, timestamp: false)}"
      else
        @brand.logo.url(logo.first, timestamp: false)
      end
    end
  end

  node(:logo) do |brand|
    if S3_STORAGE[:storage] == :filesystem
      "#{request.protocol}#{request.host}#{brand.logo.url(:original, timestamp: false)}"
    else
      brand.logo.url(:original, timestamp: false)
    end
  end
end

node(:website) do |brand|
  "#{request.protocol}#{brand.default_website.url}"
end

