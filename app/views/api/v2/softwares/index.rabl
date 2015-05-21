collection @softwares
attributes :name, :formatted_name, :version, :platform

node(:id) { |s| s.friendly_id }
node(:direct_download_url) { |s| download_software_url(s, host: @brand.default_website.url) }
node(:url) { |s| api_v2_brand_software_url(@brand, s, format: request.format.to_sym, host: @brand.default_website.url).gsub!(/\?.*$/, '') }

