module TranslationHelper

  # Tries to find a ContentTranslation for the provided field for current locale. Falls
  # back to language only or default (english)
  def translate_content(object, method)
    c = object.send(method) # (default)
    return c if I18n.locale.to_s.match?(/en/i)

    if !!(object.class.columns_hash[method.to_s])
      c = ContentTranslation.translate_text_content(object, method)
      c.to_s.html_safe
    else
      product_description = object.send("#{method}_field")
      translate_content(product_description, "content_part1")
    end
  end

  def translate_image_tag(object, method, opts={})
    media_url = translate_image_url(object, method, opts)
    opts.delete(:size) # size was used for paperclip url
    opts[:lazy] ||= !!opts[:lazy]

    if opts[:alt].present? && opts[:alt].is_a?(Symbol)
      opts[:alt] = translate_content(object, opts[:alt])
    end

    image_tag(media_url, opts)
  end

  def translate_image_url(object, method, opts={})
    size = (opts[:size].present?) ? opts[:size].to_sym : :original
    m = MediaTranslation.translate_media(object, method)
    m.url(size)
  end

  def language_name_lookup(locale)
    begin
      Locale.where(code: locale).first.name
    rescue
      locale
    end
  end
end
