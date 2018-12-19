object @product
attributes :name, :description, :features, :extended_description

attribute :friendly_id => :id
attribute :short_description => :brief
node(:link) do |product|
  if @brand.live_on_this_platform?
    product_url(@product, host: @brand.default_website.url)
  elsif @product.product_page_url.present?
    if @product.product_page_url.to_s.match(/^http/)
      @product.product_page_url
    else
      "http://#{ @product.product_page_url } "
    end
  end
end

child(:brand) do
  attributes :name
  node(:url) do |brand|
    if brand.live_on_this_platform?
      api_v2_brand_url(brand, format: request.format.to_sym, host: brand.default_website.url).gsub!(/\?.*$/, '')
    else
      # use the host the request came in on
      api_v2_brand_url(brand, format: request.format.to_sym).gsub!(/\?.*$/, '')
    end
  end
end

child @product.images_for("product_page") => :images do
  extends 'api/v2/product_attachments/show'
end

child (@product.product_documents.includes(:product) + @product.viewable_site_elements.select{|d| d if can?(:read, d)}) => :documents do
  node(:name) { |d| (d.is_a?(SiteElement)) ? d.name : d.name(hide_product_name: true) }
  node(:url) do |d|
    url = (d.is_a?(SiteElement)) ? d.url : d.document.url
    url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
    url
  end
  node(:type) do |d|
    if d.is_a?(SiteElement)
      (d.resource_content_type.present?) ? d.resource_content_type : d.executable_content_type
    else
      d.document_content_type
    end
  end
  node(:doctype) { |d| (d.is_a?(SiteElement)) ? d.resource_type : I18n.t("document_type.#{d.document_type}") }
  node(:size) do |d|
    if d.is_a?(SiteElement)
      (d.resource_file_size.present?) ? d.resource_file_size : d.executable_file_size
    else
      d.document_file_size
    end
  end
end

child (@product.active_softwares + @product.executable_site_elements.select{|d| d if can(:read, d)}) => :software do
  node(:name) { |d| (d.is_a?(SiteElement)) ? d.name : d.formatted_name }
  node(:url) do |d|
    if d.is_a?(SiteElement)
      url = d.executable.url
      url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
      url
    else
      if d.link.present?
        d.link = "http://" + d.link unless d.link.match(/^http/)
        d.link
      else
        d.ware.url
      end
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

