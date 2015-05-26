object @software
attributes :name, :formatted_name, :version, :platform, :description

attribute :friendly_id => :id

node(:direct_download_url) do |s|
  if s.link.present?
    s.link = "http://" + s.link unless s.link.match(/^http/)
    s.link
  else
    s.ware.url
  end
end

node(:link) do |s|
  if @brand.live_on_this_platform?
    software_url(s, host: @brand.default_website.url).gsub!(/\?.*$/, '')
  else
    software_url(s)
  end
end

child(:brand) do
  attributes :name
  node(:url) do |brand|
    if @brand.live_on_this_platform?
      api_v2_brand_url(@software.brand, format: request.format.to_sym, host: @software.brand.default_website.url).gsub!(/\?.*$/, '')
    else
      api_v2_brand_url(@software.brand, format: request.format.to_sym).gsub!(/\?.*$/, '')
    end
  end
end
