ThinkingSphinx::Index.define :product_family, name: "product_family_en", with: :active_record do
  # :nocov:
  indexes name, intro, keywords
  # :nocov:
end

ThinkingSphinx::Index.define :product_family, name: "product_family_en_US", with: :active_record do
  # :nocov:
  indexes name, intro, keywords
  # :nocov:
end

(WebsiteLocale.pluck(:locale).uniq - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :product_family, name: "product_family_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes name
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
