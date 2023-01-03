ThinkingSphinx::Index.define :product_review, name: "product_review_en", with: :active_record do
  # :nocov:
  indexes title, body
  # :nocov:
end

ThinkingSphinx::Index.define :product_review, name: "product_review_en_US", with: :active_record do
  # :nocov:
  indexes title, body
  # :nocov:
end

(Locale.all_unique_locales - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :product_review, name: "product_review_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
