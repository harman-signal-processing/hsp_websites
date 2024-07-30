ThinkingSphinx::Index.define :product_family, name: "product_family_en", with: :active_record do
  # :nocov:
  indexes name, :as => :product_family_name
  indexes intro, :as => :product_family_intro
  indexes keywords, :as => :product_family_keywords
  indexes features.pre_content, as: :product_family_feature_pre_content, :facet => true
  indexes features.content, as: :product_family_feature_content, :facet => true

  set_property :delta => :delayed
  set_property :delta_column => :updated_at
  # :nocov:
end

ThinkingSphinx::Index.define :product_family, name: "product_family_en_US", with: :active_record do
  # :nocov:
  indexes name, :as => :product_family_name
  indexes intro, :as => :product_family_intro
  indexes keywords, :as => :product_family_keywords
  indexes features.pre_content, as: :product_family_feature_pre_content, :facet => true
  indexes features.content, as: :product_family_feature_content, :facet => true

  set_property :delta => :delayed
  set_property :delta_column => :updated_at
  # :nocov:
end

(Locale.all_unique_locales - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :product_family, name: "product_family_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes name
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
