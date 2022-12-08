class Locale < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  # Find all top-level, language-only locales
  scope :primaries, -> { where.not("code LIKE '%-%'") }

  # config/routes.rb uses these locales to setup routes.
  # returns an array of locale codes (both language-only and language-region style)
  def self.all_unique_locales
    begin
      # 2022-10 [AA] Now that RV is launching pages without completing the
      #   translation, we just enable ALL locales for routing
      #where(complete: true).pluck(:locale).uniq
      all.pluck(:code).uniq
    rescue
      AVAILABLE_LOCALES
    end
  end

  # Find related WebsiteLocales by matching the code
  # (Ran into many problems trying to make this a traditional id-based
  # relationship. May revisit later.)
  def website_locales
    WebsiteLocale.where(locale: self.code)
  end

  # Primary Locales are basically language-only
  #   for example: en
  def is_primary?
    !is_regional?
  end

  # Regional Locales have a language code followed by a regional code
  #  for example: en-asia
  def is_regional?
    regional_code.present?
  end

  # If this locale is a primary locale, find any regionals by matching
  # the language portion of the code
  def regionals
    @regionals ||= is_primary? ?
      Locale.where("code LIKE ?", "#{code}-%").where.not(id: self.id) :
      nil
  end

  # If this locale is a regional locale, find its primary (parent)
  # by matching the language code
  def primary
    @primary ||= is_regional? ? Locale.where(code: language_code).first : self
  end

  # The first part of the code is the language identifier
  def language_code
    @language_code ||= code_parts[0]
  end

  # The second part of the code is the regional portion
  # Returns nil if this locale is a primary (language-only)
  def regional_code
    @regional_code ||= code_parts[1]
  end

  # Split the code into segments so we can isolate parts of it
  def code_parts
    @code_parts ||= code.to_s.split("-")
  end

end
