module SeoHelper

  def canonical_link
    url = request.protocol + website.brand.default_website.url
    if website.locale
      url += request.path.sub(/^\/[\w\-]*/, "/#{website.locale}")
    else
      url += request.path
    end
    tag(:link, rel: 'canonical', href: url)
  end

  def cached_meta_tags
    @page_description ||= website.value_for('default_meta_tag_description')
    @page_keywords ||= website.value_for("default_meta_tag_keywords")
    begin
      canonical_link + display_meta_tags(site: Setting.site_name(website))
    rescue
    end
  end

end
