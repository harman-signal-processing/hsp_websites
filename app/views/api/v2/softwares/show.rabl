object @software
attributes :name, :formatted_name, :version, :platform, :description

attribute :friendly_id => :id

node(:direct_download_url) { |s| download_software_url(s, host: @brand.default_website.url) }
node(:link) { |s| software_url(s, host: @brand.default_website.url) }

child(:brand) do
  attributes :name
  node(:url) { |brand| api_v2_brand_url(@software.brand, format: request.format.to_sym, host: @software.brand.default_website.url).gsub!(/\?.*$/, '') }
end
