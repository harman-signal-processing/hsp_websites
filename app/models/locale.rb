class Locale < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  # Probably not the best way to do this, but the routes.rb file uses these locales
  # to setup routes.
  # TODO: Routing could be smarter (restricting locales to corresponding websites)
  def self.all_unique_locales
    begin
      if Rails.env.test? # not cool, but only thing I can get working for testing
        [I18n.default_locale]
      else
        # 2022-10 [AA] config/routes.rb uses this to setup routes for locales. Now
        #   that RV is launching pages without completing the translation, we just
        #   enable ALL locales for routing
        #where(complete: true).pluck(:locale).uniq
        all.pluck(:code).uniq
      end
    rescue
      AVAILABLE_LOCALES
    end
  end

  def website_locales
    WebsiteLocale.where(locale: self.code)
  end

end
