xml.instruct! :xml, version: "1.0"

xml.product name: @software.formatted_name do
  xml.link url: software_url(@software, host: @software.brand.default_website.url)
  xml.id @software.friendly_id, type: 'text'
  xml.brand @software.brand.name, api_url: api_v2_brand_url(@product.brand, host: @product.brand.default_website.url).gsub!(/\?.*$/, '')
  xml.description @software.description, type: 'html'
end
