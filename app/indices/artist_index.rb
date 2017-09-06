ThinkingSphinx::Index.define :artist, name: "artist_en", with: :active_record do
  # :nocov:
  indexes name
  indexes bio
  # :nocov:
end

ThinkingSphinx::Index.define :artist, name: "artist_en_US", with: :active_record do
  # :nocov:
  indexes name
  indexes bio
  # :nocov:
end

(WebsiteLocale.pluck(:locale).uniq - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :artist, name: "artist_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes name
    indexes content_translations.content, as: :bio

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
