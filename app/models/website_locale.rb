class WebsiteLocale < ActiveRecord::Base
  belongs_to :website, touch: true
  validates :website_id, presence: true
  validates :locale, presence: true
#  after_save :restart_site

  # Probably not the best way to do this, but the routes.rb file uses these locales
  # to setup routes.
  # TODO: Routing could be smarter (restricting locales to corresponding websites)
  def self.all_unique_locales
    begin
      if Rails.env.test? # not cool, but only thing I can get working for testing
        [I18n.default_locale]
      else
        where(complete: true).pluck(:locale).uniq
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

  # Restart the site if a new locale is activated
  def restart_site
    if self.complete? && self.complete_changed?
      `touch #{Rails.root.join("tmp", "restart.txt")}`
    end
  end
end
