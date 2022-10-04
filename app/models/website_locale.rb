class WebsiteLocale < ApplicationRecord
  belongs_to :website, touch: true
  validates :locale, presence: true

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
        all.pluck(:locale).uniq
      end
    rescue
      AVAILABLE_LOCALES
    end
  end

  # Probably not the best way to do this, but the routes.rb file uses these locales
  # to setup routes. This method is used by the admin router so translators can work
  # on locales which aren't yet published.
  def self.all_unique_and_incomplete_locales
    begin
      if Rails.env.test? # not cool, but only thing I can get working for testing
        [I18n.default_locale]
      else
        pluck(:locale).uniq
      end
    rescue
      AVAILABLE_LOCALES
    end
  end

end
