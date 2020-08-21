collection @softwares
attributes :name, :formatted_name, :version, :platform

attribute :friendly_id => :id

node(:direct_download_url) do |s|
  if s.link.present?
    s.link = request.protocol + s.link unless s.link.match(/^http/)
    s.link
  else
    s.ware.url
  end
end

node(:url) do |s|
  if @brand.live_on_this_platform?
    api_v2_brand_software_url(@brand, s, format: request.format.to_sym, host: @brand.default_website.url).gsub!(/\?.*$/, '')
  else
    api_v2_brand_software_url(@brand, s, format: request.format.to_sym).gsub!(/\?.*$/, '')
  end
end

