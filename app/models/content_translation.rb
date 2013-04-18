class ContentTranslation < ActiveRecord::Base
  validates_presence_of :content_id, :content_method, :locale
  validates :content, presence: true
  validates :content_type, presence: true
  
  # Here's my big configuration table which shows which fields can be translated.
  # These have been updated in the views so that instead of just showing a value,
  # we search for translated content for the given locale.
  def self.translatables(brand=Brand.first)
    t = {
      "product"        => %w{description extended_description features short_description keywords},
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
  
end
