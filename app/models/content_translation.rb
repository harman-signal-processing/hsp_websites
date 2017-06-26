class ContentTranslation < ApplicationRecord
  validates :content_id, presence: true
  validates :content_method, presence: true
  validates :locale, presence: true
  validates :content, presence: true
  validates :content_type, presence: true

  # Here's my big configuration table which shows which fields can be translated.
  # These have been updated in the views so that instead of just showing a value,
  # we search for translated content for the given locale.
  def self.translatables(brand=Brand.first)
    t = {
      "product"        => %w{name short_description keywords},
      "product_description" => %w{content_part1},
      "product_family" => %w{name intro keywords},
      "feature"        => %w{pre_content content},
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
      t["market_segment"] = %w{name description}
    end
    t
  end

  def self.fields_to_translate_for(object, brand)
    translatables(brand)[object.class.name.underscore]
  end

  # Tries to find a ContentTranslation for the provided field for current locale. Falls
  # back to language only or default (english)
  def self.translate_text_content(object, method)
    c = object[method] # (default)
    return c if I18n.locale == I18n.default_locale || I18n.locale == 'en'

    parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false
    translations = where(content_type: object.class.to_s, content_id: object.id, content_method: method.to_s)

    if t = translations.where(locale: I18n.locale).first
      c = t.content
    elsif parent_locale
      if t = translations.where(locale: parent_locale).first
        c = t.content
      elsif t = translations.where("locale LIKE ?", "#{parent_locale}%%").first
        c = t.content
      end
    end
    c
  end

end
