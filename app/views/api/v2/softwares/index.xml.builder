xml.instruct! :xml, version: "1.0"

xml.softwares do
  @softwares.each do |software|
    xml.software(
      software.formatted_name,
      name: software.name,
      id: software.friendly_id,
      version: software.version,
      platform: software.platform,
      direct_download_url: download_software_url(software, host: @brand.default_website.url),
      url: api_v2_brand_software_url(@brand, software, format: :xml, host: @brand.default_website.url).gsub!(/\?.*$/, '')
    )
  end
end
