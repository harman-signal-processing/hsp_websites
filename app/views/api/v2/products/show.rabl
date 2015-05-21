object @product
attributes :name, :description, :features, :extended_description

attribute :friendly_id => :id
attribute :short_description => :brief
node(:link) { |product| product_url(@product, host: @brand.default_website.url) }

child(:brand) do
  attributes :name
  node(:url) { |brand| api_v2_brand_url(@product.brand, format: request.format.to_sym, host: @product.brand.default_website.url).gsub!(/\?.*$/, '') }
end

child @product.images_for("product_page") => :images do
  extends 'api/v2/product_attachments/show'
end

child (@product.product_documents.includes(:product) + @product.viewable_site_elements) => :documents do
  node(:name) { |d| (d.is_a?(SiteElement)) ? d.name : d.name(hide_product_name: true) }
  node(:url) do |d|
    url = (d.is_a?(SiteElement)) ? d.resource.url : d.document.url
    url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
    url
  end
  node(:type) { |d| (d.is_a?(SiteElement)) ? d.resource_content_type : d.document_content_type }
  node(:doctype) { |d| (d.is_a?(SiteElement)) ? d.resource_type : I18n.t("document_type.#{d.document_type}") }
  node(:size) { |d| (d.is_a?(SiteElement)) ? d.resource_file_size : d.document_file_size }
end

child (@product.active_softwares + @product.executable_site_elements) => :software do
  node(:name) { |d| (d.is_a?(SiteElement)) ? d.name : d.formatted_name }
  node(:url) do |d|
    if d.is_a?(SiteElement)
      url = d.executable.url
      url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
      url
    else
      software_url(d, host: @brand.default_website.url)
    end
  end
  node(:type) { |d| (d.is_a?(SiteElement)) ? d.executable_content_type : d.ware_content_type }
  node(:size) { |d| (d.is_a?(SiteElement)) ? d.executable_file_size : d.ware_file_size }
  node(:doctype) { |d| (d.is_a?(SiteElement)) ? d.resource_type : d.category }
end

child @product.product_specifications.includes(:specification) => :specifications do
  attribute :value
  node(:name) { |s| s.specification.name }
end

