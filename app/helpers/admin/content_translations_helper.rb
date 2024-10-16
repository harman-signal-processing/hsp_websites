module Admin::ContentTranslationsHelper

  # Need to know what "name" to show for the given record which
  # could have a :name, :title, or :something_else
  def link_to_translate(object, locale=I18n.default_locale)
    # ct = ContentTranslation.where(content_type: object.class.to_s,
    #       content_id: object.id,
    #       content_method: "hmmm",
    #       locale: locale)
    link_to(name_for(object), combined_admin_content_translations_path(
                    locale: I18n.locale,
                    target_locale: locale,
                    type: object.class.to_s.underscore,
                    id: object.id) )
  end

  def fields_translated_for(item, target_locale)
    ContentTranslation.where(
      content_type: item.class,
      content_id: item.id,
      locale: target_locale) +
     MediaTranslation.where(
       media_type: item.class,
       media_id: item.id,
       locale: target_locale)
  end

  def total_to_translate_for(item, target_locale)
    ContentTranslation.fields_to_translate_for(item, website.brand) +
      MediaTranslation.fields_to_translate_for(item, website.brand)
  end

  def translation_summary_for(item, target_locale)
    finished = fields_translated_for(item, target_locale).size
    total_to_translate = total_to_translate_for(item, target_locale).size
    unless item.is_a?(Product) # loop takes too long for products
      total_to_translate_for(item, target_locale).each do |field_name|
        total_to_translate -= 1 if item.send(field_name).blank?
      end
    end

    ContentTranslation.description_translatables_for(item, website.brand, target_locale).each do |d|
      finished += 1 unless d.new_record?
      total_to_translate += 1
    end
    style = "color: red" if finished < total_to_translate

    content_tag(:span, finished, style: style) + " / " + raw(total_to_translate)
  end

end

