object @site_element
attributes :name

attribute :resource_type => :doctype

node(:url) do |d|
  url = d.executable_file_name.present? ? d.executable.url : d.resource.url
  url = "http://#{request.host}#{url}" if S3_STORAGE[:storage] == :filesystem
  url
end

node(:type) { |d| d.executable_file_name.present? ? d.executable_content_type : d.resource_content_type }
node(:size) { |d| d.executable_file_name.present? ? d.executable_file_size : d.resource_file_size }
