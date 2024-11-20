class ContentTranslation < ApplicationRecord
  belongs_to :translatable, polymorphic: true, foreign_type: "content_type", foreign_key: "content_id", touch: true

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
      "product"        => %w{name short_description}, # keywords meta_description},
      "product_description" => %w{content_part1},
      "product_family" => %w{name intro short_description before_product_content accessories_content post_content}, # keywords meta_description},
      "feature"        => %w{pre_content content},
      "specification"  => %w{name},
      "product_specification" => %w{value},
      "specification_group" => %w{name},
      "news"           => %w{title quote body},
      "page"           => %w{title description body},
      #"promotion"      => %w{name description}  # promos are really for US only
    }
    if brand.has_effects?
      t["effect_type"] = %w{name}
      t["effect"] = %w{name}
    end
    if brand.has_reviews?
      t["product_review"] = %w{title body}
    end
    if brand.has_artists? && brand.artists.size > 0
      t["artist"] = %w{bio}
    end
    if brand.has_faqs?
      t["faq"] = %w{question answer}
    end
    if brand.has_market_segments? && brand.market_segments.size > 0
      t["market_segment"] = %w{name description}
    end
    t
  end

  def self.translatable_classes
    [Product, ProductDescription, ProductFamily, Feature, Specification, ProductSpecification, SpecificationGroup, News, Page, Promotion,
     EffectType, Effect, ProductReview, Artist, Faq, MarketSegment]
  end
  def self.fields_to_translate_for(object, brand)
    translatables(brand)[object.class.name.underscore]
  end

  # Tries to find a ContentTranslation for the provided field for current locale. Falls
  # back to language only or default (english)
  def self.translate_text_content(object, method)
    c = object[method] # (default)
    return c if I18n.locale.to_s.match?(/en/i)

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

  def self.description_translatables_for(item, brand, target_locale)
    description_translations = []
    if item.is_a?(Product)
      new_record = ProductDescription.new

      ProductDescription.where(product_id: item.id).each do |record|
        ContentTranslation.fields_to_translate_for(new_record, brand).each do |field_name|
          description_translations << ContentTranslation.where(
            content_type: ProductDescription,
            content_id: record.id,
            content_method: field_name,
            locale: target_locale).first_or_initialize
        end
      end
    end
    description_translations
  end

  def self.feature_translatables_for(item, brand, target_locale)
    feature_translations = []
    new_record = Feature.new
    Feature.where(featurable_id: item.id, featurable_type: item.class.to_s).each do |record|
      ContentTranslation.fields_to_translate_for(new_record, brand).each do |field_name|
        feature_translations << ContentTranslation.where(
          content_type: Feature,
          content_id: record.id,
          content_method: field_name,
          locale: target_locale).first_or_initialize
      end
    end
    feature_translations
  end

  def original_item
    klass = ContentTranslation.translatable_classes.find do |ct|
      ct.to_s == content_type.classify
    end
    klass.find(content_id)
  end

  def original_value
    original_item.send(content_method)
  end

  def header
    @header ||= if original_item.respond_to?(:specification)
                  original_item.specification.name.titleize
                elsif original_item.is_a?(Feature)
                  original_item.name
                elsif original_item.respond_to?(:content_name)
                  original_item.content_name.titleize
                end.to_s + " \"#{content_method.titleize}\""
  end

  # text, mediumtext, etc.
  def edit_as_html?
    original_item.class.columns_hash[content_method].type.to_s.match?(/text/i)
  end

end
