object @product_family

attributes :name
attribute :friendly_id => :id
attribute :intro => :description

child parent: :parent_family do
  attribute :name
  node(:url) { |p| api_v2_brand_product_family_url(@brand, p, format: request.format.to_sym).gsub!(/\?.*$/, '') }
end

node :locales do |pf|
  pf.locales(website)
end

node :urls do |pf|
  pf.locales(website).map { |locale| product_family_url(pf, locale: locale) }
end

if @product_family.locales(website).include?("en-US")
  node(:wave) { |pf|
    wave_api_v2_brand_product_family_url(@brand, pf, format: 'xls').gsub!(/\?.*$/, '')
  }
end

child @product_family.children_with_current_products(website) => :sub_families do
  attribute :name
  node(:url) { |pf| api_v2_brand_product_family_url(@brand, pf, format: request.format.to_sym).gsub!(/\?.*$/, '') }
  node(:wave) { |pf|
    if pf.locales(website).include?("en-US")
      wave_api_v2_brand_product_family_url(@brand, pf, format: 'xls').gsub!(/\?.*$/, '')
    end
  }
end

child @product_family.current_products => :products do
  attribute :name
  node(:url) { |p| api_v2_brand_product_url(@brand, p, format: request.format.to_sym).gsub!(/\?.*$/, '') }
end
