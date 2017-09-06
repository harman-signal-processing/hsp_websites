ThinkingSphinx::Index.define :software, name: "software_en", with: :active_record do
  # :nocov:
  indexes name, version, platform, description
  # :nocov:
end

ThinkingSphinx::Index.define :software, name: "software_en_US", with: :active_record do
  # :nocov:
  indexes name, version, platform, description
  # :nocov:
end

(WebsiteLocale.pluck(:locale).uniq - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :software, name: "software_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes name
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
