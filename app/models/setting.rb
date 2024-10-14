class Setting < ApplicationRecord
  before_save :fix_locale
  has_attached_file :slide, {
    styles: {
      x_large: ["2048x1536", :webp],
      x_large_2x: ["4096x3072", :webp],
      large: ["1920>x692", :webp],
      large_2x: ["3840>x1384", :webp],
      medium: "350x350>",
      thumb: "100x100>",
      tiny: "64x64>",
      tiny_square: "64x64#"
    },
    processors: [:thumbnail, :compression],
  }.merge(SETTINGS_STORAGE)
  validates_attachment :slide,
    content_type: { content_type: /\A(image|video)/i },
    size: { in: 0..300.kilobytes }
  before_slide_post_process :skip_for_video, :skip_for_gifs
  process_in_background :slide

  belongs_to :brand, touch: true
  has_one :promotion, foreign_key: 'banner_id', dependent: :nullify, inverse_of: :banner
  validates :name, presence: true, uniqueness: { scope: [:locale, :brand_id], case_sensitive: false  }

  scope :unset_for_brand, -> (brand) {
    where.not(brand_id: Brand.where(live_on_this_platform: false).pluck(:id) + [brand.id]).
    where.not(name: brand.settings.pluck(:name)).
    where.not(setting_type: ["slideshow frame", "homepage feature", "products homepage slideshow frame"])
  }

  # Borrow description from another site setting with the same name if
  # one exists.
  def steal_description
    if self.description.blank?
      other = Setting.unscoped.where(name: self.name).where.not(description: ['', nil]).limit(1)
      if other.size > 0
        self.description = other.first.description
      end
    end
  end

  def skip_for_video
    ! slide_content_type.match?(/video/)
  end

  def skip_for_gifs
    ! slide_content_type.match?(/gif/)
  end

  def self.setting_types
    ["string", "integer", "text", "slideshow frame", "homepage feature", "products homepage slideshow frame"]
  end

  # Collect all Settings which are designated as 'slideshow frame' for the homepage.
  # Note: the integer_value is used for the position, and the string_value is used
  # to hyperlink when the frame is displayed. Now with I18n. (See #value)
  def self.slides(website, options={})
    setting_type = options[:setting_type] ||'slideshow frame'
    s = where("brand_id = ? and setting_type = ?", website.brand_id, setting_type).where("slide_file_name IS NOT NULL")
    unless options[:showall]
      s = s.where("start_on IS NULL OR start_on <= ?", Date.today).where("remove_on IS NULL OR remove_on > ?", Date.today)
    end
    s = s.order(:integer_value)
    defaults = s.where("locale IS NULL or locale = ?", I18n.locale)
    locale_slides = nil
    unless I18n.locale == I18n.default_locale # don't look for translation
      s1 = s.where(["locale = ?", I18n.locale]) # try "foo_es-MX" (for example)
      if s1.all.size > 0
        locale_slides = s1
      elsif parent_locale = (I18n.locale.to_s.match(/^(.*)-/)) ? $1 : false # "es-MX" => "es"
        s2 = s.where(["locale = ?", parent_locale]) # try "foo_es"
        if s2.all.size > 0
          locale_slides = s2
        end
      end
    end
    slides = (locale_slides) ? locale_slides : defaults
    (options[:limit].present?) ? slides.limit(options[:limit]) : slides
  end

  # Collect all Settings which are homepage features
  def self.features(website, options={})
    f = where(brand_id: website.brand_id).where(setting_type: "homepage feature").where("slide_file_name IS NOT NULL")
    unless options[:showall]
      f = f.where("start_on IS NULL OR start_on <= ?", Date.today).where("remove_on IS NULL OR remove_on > ?", Date.today)
    end
    f = f.order(:integer_value)
    f
  end

  # Wrapper to grab the site name
  def self.site_name(website)
    begin
      where(brand_id: website.brand_id).where(name: "site_name").first.value
    rescue
      HarmanSignalProcessingWebsite::Application.config.default_site_name
    end
  end

  def fix_locale
    if self.locale.blank?
      self.locale = nil
    end
  end

  # Determines the value of the current Setting. Values can come
  # from the string, text, integer, or slide attachment.
  def value(locale=I18n.locale)
    begin
      (setting_type =~ /slide|feature/) ? slide : self.send("#{setting_type.to_param}_value")
    rescue
      nil
    end
  end

end
