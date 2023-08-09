module SeoHelper

  def canonical_link
    tag(:link, rel: 'canonical', href: canonical_url)
  end

  # Consolidates www and non www domains
  def canonical_url
    request.protocol + website.brand.default_website.url + request.path
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
    langs = []

    # skip since en-asia is not a SEO recognized locale
    exclude_locales = ["en-asia"]

    begin
      if @hreflangs # defined in the controller for the current request
        this_url_all_locales = @hreflangs
      else
        this_url_all_locales = website.available_locales.map{|wl| wl.locale}
      end

      (this_url_all_locales.uniq - exclude_locales).each do |locale|
        if request.path.match(/^\/(#{ dashed_locales_regex })/)
          locale_url = full_url_for(request.params.merge(locale: locale))
          langs << tag(:link, rel: 'alternate', href: locale_url, hreflang: locale.downcase)
          if locale.to_s == I18n.default_locale.to_s
            langs << tag(:link, rel: 'alternate', href: locale_url, hreflang: "x-default")
          end
        elsif request.path.match(/^\/(#{ parent_locales_regex })/)
          locale_url = full_url_for(request.params.merge(locale: locale))
          langs << tag(:link, rel: 'alternate', href: locale_url, hreflang: locale.downcase)
          if locale.to_s == I18n.default_locale.to_s
            langs << tag(:link, rel: 'alternate', href: locale_url, hreflang: "x-default")
          end
        end
      end
      langs.join("\n").html_safe
    rescue
      # avoid errors since this now runs on every page
    end
  end

  def dashed_locales_regex
    @dashed_locales_regex ||= I18n.available_locales.select{|l| l.to_s if l.match(/\-/)}.join("|")
  end

  def parent_locales_regex
    @parent_locales_regex ||= I18n.available_locales.select{|l| l.to_s unless l.match(/\-/)}.join("|")
  end

end
