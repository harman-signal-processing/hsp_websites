ThinkingSphinx::Index.define :news, name: "news_en", with: :active_record do
  # :nocov:
  indexes title, :as => :news_title
  indexes body, :as => :news_body
  indexes keywords, :as => :news_keywords
  # :nocov:
end

ThinkingSphinx::Index.define :news, name: "news_en_US", with: :active_record do
  # :nocov:
  indexes title, :as => :news_title
  indexes body, :as => :news_body
  indexes keywords, :as => :news_keywords
  # :nocov:
end

(Locale.all_unique_locales - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :news, name: "news_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
