object @product_document
attribute :document_content_type => :type
attribute :document_file_size => :size

node(:name) { |d| d.name(hide_product_name: true) }

node(:url) do |d|
  url = d.document.url
  url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
  url
end

node(:doctype) { |d| I18n.t("document_type.#{d.document_type}") }
