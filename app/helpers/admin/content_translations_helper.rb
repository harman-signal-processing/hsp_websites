module Admin::ContentTranslationsHelper

  def fields_translated_for(item, target_locale)
    ContentTranslation.where(
      content_type: item.class,
      content_id: item.id,
      locale: target_locale)
  end

  def total_to_translate_for(item, target_locale)
    ContentTranslation.fields_to_translate_for(item, website.brand)
  end

  def translation_summary_for(item, target_locale)
    finished = fields_translated_for(item, target_locale).size
    total_to_translate = total_to_translate_for(item, target_locale).size

    ContentTranslation.description_translatables_for(item, website.brand, target_locale).each do |d|
      finished += 1 unless d.new_record?
      total_to_translate += 1
    end
    style = "color: red" if finished < total_to_translate

    content_tag(:span, finished, style: style) + " / " + raw(total_to_translate)
  end

end

