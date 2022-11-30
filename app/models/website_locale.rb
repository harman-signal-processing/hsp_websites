class WebsiteLocale < ApplicationRecord
  belongs_to :website, touch: true
  validates :locale, presence: true

  def self.all_unique_locales
    Locale.all_unique_locales
  end

  def name
    begin
      Locale.where(code: self.locale).first.name
    rescue
      self.locale
    end
  end

end
