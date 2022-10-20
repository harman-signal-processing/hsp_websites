module TranslationHelper

  # Tries to find a ContentTranslation for the provided field for current locale. Falls
  # back to language only or default (english)
  def translate_content(object, method)
    c = object.send(method) # (default)
    return c if I18n.locale.to_s.match?(/en/)

    if !!(object.class.columns_hash[method.to_s])
      translations = ContentTranslation.where(content_type: object.class.to_s, content_id: object.id, content_method: method.to_s)
      parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false
      if t = translations.where(locale: I18n.locale).first
        c = t.content
      elsif parent_locale
        if t = translations.where(locale: parent_locale).first
          c = t.content
        elsif t = translations.where(["locale LIKE ?", "'#{parent_locale}%%'"]).first
          c = t.content
        end
      end
      c.to_s.html_safe
    else
      product_description = object.send("#{method}_field")
      translate_content(product_description, "content_part1")
    end
  end

end
