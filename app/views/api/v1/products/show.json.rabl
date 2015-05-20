object @product
attributes :id, :name, :friendly_id, :harman_employee_price, :msrp, :sap_sku, :short_description, :description, :stock_status, :available_on

node(:thumbnail) { |product|
  if product.photo
    if S3_STORAGE[:storage] == :filesystem
      "http://#{request.host_with_port}#{product.photo.product_attachment.url(:thumb, timestamp: false)}"
    else
      product.photo.product_attachment.url(:thumb, timestamp: false)
    end
  else
    "http://#{request.host_with_port}#{image_path('missing-image-22x22.png')}"
  end
}

node(:photo) { |product|
  if product.photo
    if S3_STORAGE[:storage] == :filesystem
      "http://#{request.host}#{product.photo.product_attachment.url(:medium, timestamp: false)}"
    else
      product.photo.product_attachment.url(:medium, timestamp: false)
    end
  else
    "http://#{request.host_with_port}#{image_path('missing-image-128x128.png')}"
  end
}

node(:url) {|product|
  if product.brand.live_on_this_platform?
    product_url(product, host: product.brand.default_website.url, locale: I18n.default_locale)
  elsif product.more_info_url.present?
    product.more_info_url
  elsif product.brand.respond_to?(:external_url)
    product.brand.external_url
  else
    nil
  end
}
