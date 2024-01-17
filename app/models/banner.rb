class Banner < ApplicationRecord
  belongs_to :bannerable, polymorphic: true, touch: true
  has_many :banner_locales, dependent: :destroy

  def default_content
    banner_locales.find_by(default: true)
  end

  def content_for_current_locale
    preferred_content = banner_locales.find_by(locale: I18n.locale)
    if preferred_content.has_content?
      preferred_content
    elsif default_content.present?
      default_content
    else
      BannerLocale.new()
    end
  end

  def banner_locales_without_content
    banner_locales.select{|bl| bl if !bl.has_content?}
  end
end
