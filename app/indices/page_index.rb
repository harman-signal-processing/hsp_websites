ThinkingSphinx::Index.define :page, name: "page_en", with: :active_record do
  # :nocov:
  indexes title, :as => :landing_page_title
  indexes keywords, :as => :landing_page_keywords
  indexes description, :as => :landing_page_description
  indexes body, :as => :landing_page_body
  indexes custom_route, :as => :landing_page_custom_route

  set_property :delta => :delayed
  set_property :delta_column => :updated_at
  # :nocov:
end

ThinkingSphinx::Index.define :page, name: "page_en_US", with: :active_record do
  # :nocov:
  indexes title, :as => :landing_page_title
  indexes keywords, :as => :landing_page_keywords
  indexes description, :as => :landing_page_description
  indexes body, :as => :landing_page_body
  indexes custom_route, :as => :landing_page_custom_route

  set_property :delta => :delayed
  set_property :delta_column => :updated_at
  # :nocov:
end

(Locale.all_unique_locales - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :page, name: "page_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
