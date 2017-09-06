ThinkingSphinx::Index.define :product, name: "product_en", with: :active_record do
  # :nocov:
  indexes name,
  	sap_sku,
  	keywords,
#  	description,
  	short_description,
#  	extended_description,
#  	features,
  	short_description_1,
  	short_description_2,
  	short_description_3,
  	short_description_4

  indexes product_descriptions.content_part1, as: :description, :facet => true
  # :nocov:
end

ThinkingSphinx::Index.define :product, name: "product_en_US", with: :active_record do
  # :nocov:
  indexes name,
  	sap_sku,
  	keywords,
#  	description,
  	short_description,
#  	extended_description,
#  	features,
  	short_description_1,
  	short_description_2,
  	short_description_3,
  	short_description_4

  indexes product_descriptions.content_part1, as: :description, :facet => true
  # :nocov:
end

(WebsiteLocale.pluck(:locale).uniq - ["en", "en-US"]).each do |locale|
  locale_underscored = locale.to_s.gsub(/\-/, "_")

  ThinkingSphinx::Index.define :product, name: "product_#{ locale_underscored }", with: :active_record do
    # :nocov:
    indexes name
    indexes content_translations.content

    where "content_translations.locale = '#{ locale.to_s }'"
    # :nocov:
  end
end
