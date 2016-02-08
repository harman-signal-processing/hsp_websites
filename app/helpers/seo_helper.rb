module SeoHelper

  def canonical_locale
    if website.locale && website.locale.to_s.match(/^(\w{2})/)
      cl = $1
      if website.list_of_available_locales.include?(cl)
        cl
      else
        website.locale
      end
    else
      I18n.default_locale
    end
  end

  def canonical_link
    tag(:link, rel: 'canonical', href: canonical_url)
  end

  def canonical_url
    url = request.protocol + website.brand.default_website.url
    if request.path.match(/^\/(#{ dashed_locales_regex })\//)
      url_locale = $1
      url + request.path.sub(/#{ url_locale }/, canonical_locale) # es-MX => en
    else
      url + request.path # /landing-page => unchanged
    end
  end

  def cached_meta_tags
    @page_description ||= website.value_for('default_meta_tag_description')
    @page_keywords ||= website.value_for("default_meta_tag_keywords")
    begin
      canonical_link + display_meta_tags(site: Setting.site_name(website))
    rescue
    end
  end

  def hreflang_links
    ret = ""
    url = request.protocol + website.brand.default_website.url
    website.available_locales.each do |wl|
      if wl.locale == canonical_locale # (default locale)
        ret += tag(:link, rel: 'alternate', href: canonical_url, hreflang: "x-default")
        ret += tag(:link, rel: 'alternate', href: canonical_url, hreflang: website.locale)
      elsif request.path.match(/^\/(#{ dashed_locales_regex })\//)
        original_url_locale = $1
        wl_url = url + request.path.sub(/#{ original_url_locale }/, wl.locale)
        ret += tag(:link, rel: 'alternate', href: wl_url, hreflang: wl.locale)
      elsif request.path.match(/^\/(#{ parent_locales_regex })\//)
        original_url_locale = $1
        wl_url = url + request.path.sub(/#{ original_url_locale }/, wl.locale)
        ret += tag(:link, rel: 'alternate', href: wl_url, hreflang: wl.locale)
      end
    end
    ret
  end

  def dashed_locales_regex
    @dashed_locales_regex ||= I18n.available_locales.select{|l| l.to_s if l.match(/\-/)}.join("|")
  end

  def parent_locales_regex
    @parent_locales_regex ||= I18n.available_locales.select{|l| l.to_s unless l.match(/\-/)}.join("|")
  end

end
