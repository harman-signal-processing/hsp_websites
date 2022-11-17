class MediaTranslation < ApplicationRecord
  belongs_to :translatable, polymorphic: true, foreign_type: "media_type", foreign_key: "media_id"

  validates :media_id, presence: true
  validates :media_method, presence: true
  validates :locale, presence: true
  validates :media_type, presence: true

  # This is where it gets tricky. For now let's assume we're only translating
  # images, so we need to generate all of the various sizes--which gets tricky
  # because all models with attachments don't necessarily have the same set
  # of sizes or even the same dimensions for a given named size.
  has_attached_file :media, {
    styles: {
      banner: "1500>x400",
      large: "600>x370",
      email: "580",
      medium_square: "480x480#",
      medium: "300x300>",
      small: "240",
      small_square: "250x250#",
      thumb: "100x100>",
      thumb_square: "100x100#",
      tiny: "64x64>",
      tiny_square: "64x64#"
    },
    processors: [:thumbnail, :compression]
  }
  validates_attachment :media,
    attachment_presence: true,
    content_type: { content_type: /\Aimage/i }

  def self.translatables(brand=Brand.first)
    {
      "product_family" => %w{family_photo}, # family_banner title_banner },
      "news"           => %w{news_photo},
    }
  end

  def self.translatable_classes
    [ProductFamily, News]
  end
  def self.fields_to_translate_for(object, brand)
    translatables(brand)[object.class.name.underscore] || []
  end

  def self.translate_media(object, method)
    m = object.send(method)
    return m if I18n.locale.to_s.match?(/en/i)

    translations = MediaTranslation.where(media_type: object.class.to_s, media_id: object.id, media_method: method.to_s)
    parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false

    if t = translations.where(locale: I18n.locale).first
      m = t.media
    elsif parent_locale
      if t = translations.where(locale: parent_locale).first
        m = t.media
      elsif t = translations.where(["locale LIKE ?", "'#{parent_locale}%%'"]).first
        m = t.media
      end
    end
    m
  end

  def original_item
    klass = MediaTranslation.translatable_classes.find do |mt|
      mt.to_s == media_type.classify
    end
    klass.find(media_id)
  end

  def original_value
    original_item.send(media_method)
  end

  def header
    @header ||= "\"#{media_method.titleize}\""
  end
end
