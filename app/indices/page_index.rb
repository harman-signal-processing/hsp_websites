ThinkingSphinx::Index.define :page, name: "page_en", with: :active_record do
  # :nocov:
  indexes title, keywords, description, body, custom_route
  # :nocov:
end

ThinkingSphinx::Index.define :page, name: "page_en-US", with: :active_record do
  # :nocov:
  indexes title, keywords, description, body, custom_route
  # :nocov:
end

(WebsiteLocale.pluck(:locale).uniq - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :page, name: "page_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
