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
    else
      default_content #|| BannerLocale.new()
    end
  end
end
