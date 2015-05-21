object @product_attachment

attribute :product_attachment_content_type => :type

root_object.product_attachment.styles.each do |style|
  node(style.first.to_sym) do |pa|
    url = pa.product_attachment.url(style.first, timestamp: false)
    url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
    url
  end
end

node(:url) do |pa|
  url = pa.product_attachment.url
  url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
  url
end

node(:primary_photo) { |pa| pa.product.photo && pa.product.photo == pa }
