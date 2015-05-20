xml.instruct! :xml, version: "1.0"

xml.products do
  @products.each do |product|
    xml.product(
      product.name,
      name: product.name,
      id: product.friendly_id,
      url: api_v2_brand_product_url(@brand, product, format: :xml, host: @brand.default_website.url).gsub!(/\?.*$/, '')
    )
  end
end
