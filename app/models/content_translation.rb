class ContentTranslation < ActiveRecord::Base
  require 'bing_translator'
  validates_presence_of :content_id, :content_method, :locale
  validates :content, presence: true
  validates :content_type, presence: true
  attr_accessible :content_id, :content_method, :content, :content_type, :locale
  
  # Here's my big configuration table which shows which fields can be translated.
  # These have been updated in the views so that instead of just showing a value,
  # we search for translated content for the given locale.
  def self.translatables(brand=Brand.first)
    t = {
      "product"        => %w{name description extended_description features short_description keywords},
      "product_family" => %w{name intro keywords},
      "specification"  => %w{name},
      "news"           => %w{title body},
      "page"           => %w{title description body},
      "promotion"      => %w{name description}
    }
    if brand.has_effects?
      t["amp_model"] = %w{name}
      t["cabinet"] = %w{name}
      t["effect_type"] = %w{name}
      t["effect"] = %w{name}
    end
    if brand.has_reviews?
      t["product_review"] = %w{title body}
    end
    if brand.has_artists?
      t["artist"] = %w{bio}
    end
    if brand.has_faqs?
      t["faq"] = %w{question answer}
    end
    if brand.has_market_segments?
      t["market_segment"] = %w{name}
    end
    t
  end

  def self.fields_to_translate_for(object, brand)
    translatables(brand)[object.class.name.underscore]
  end

  def self.auto_translate(object, brand)
    if HarmanSignalProcessingWebsite::Application.config.auto_translate
      locales = brand.default_website.auto_translate_locales
      fields_to_translate_for(object, brand).each do |method|
        locales.each do |locale|
          create_or_update_with_auto_translate(object, method, locale)
        end
      end
    end
  end

  # Bing translate, store results
  def self.create_or_update_with_auto_translate(object, method, locale)
    if exists?(content_type: object.class.to_s, content_id: object.id, content_method: method, locale: locale)
      update_with_auto_translate(object, method, locale)
    else
      create_with_auto_translate(object, method, locale)
    end
  end

  def auto_translate(object)
    from = I18n.default_locale.to_s.gsub(/\-.*$/, '') || 'en'
    target = locale
    target = "zh-CHS" if target.to_s.match(/^zh/i)
    original_content = object[self.content_method]

    logger.debug " ------>     from: #{from}"
    logger.debug " ------>   target: #{target}"
    logger.debug " ------> original: #{original_content}"

    unless from == target || original_content.blank?
      t = translator
      if t.supported_language_codes.include?(target) && t.supported_language_codes.include?(from)
        if content = t.translate(original_content, from: from, to: target) 
          self.content = content
          self.save
        end
      end
    end 
  end

private

  def self.create_with_auto_translate(object, method, locale)
    self.new(
      content_type: object.class.to_s,
      content_id: object.id,
      content_method: method,
      locale: locale
    ).auto_translate(object)
  end

  def self.update_with_auto_translate(object, method, locale)
    self.where(
      content_type: object.class.to_s,
      content_id: object.id,
      content_method: method,
      locale: locale
    ).first.auto_translate(object)  
  end

  def translator
    BingTranslator.new(HarmanSignalProcessingWebsite::Application.config.bing_translator_id, HarmanSignalProcessingWebsite::Application.config.bing_translator_key)
  end
  
end
