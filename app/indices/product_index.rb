ThinkingSphinx::Index.define :product, name: "product_en", with: :active_record do
  # :nocov:
  indexes name,
  	sap_sku,
  	keywords,
#  	description,
  	short_description,
#  	extended_description,
#  	features,
  # 	accessory_specifications_content,
  	short_description_1,
  	short_description_2,
  	short_description_3,
  	short_description_4

  indexes product_descriptions.content_part1, as: :description, :facet => true
  # indexes product_specifications.joins(:specification).where("specifications.name like ?","%accessories%").collect(&:value).join(","), as: :accessories
  
  # indexes product_specifications.value, as: :accessories
  
  # :nocov:
end

ThinkingSphinx::Index.define :product, name: "product_real_time_en", with: :real_time do
  indexes specifications_accessories_content
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
  # 	accessory_specifications_content,
  # product.product_specifications.joins(:specification).where("specifications.name like ?","%accessories%"),
  	short_description_1,
  	short_description_2,
  	short_description_3,
  	short_description_4

  indexes product_descriptions.content_part1, as: :description, :facet => true
  
  # indexes product_specifications.joins(:specification).where("specifications.name like ?","%accessories%").collect(&:value).join(","), as: :accessories
  # indexes product_specifications.value, as: :accessories
  
  # :nocov:
end

ThinkingSphinx::Index.define :product, name: "product_real_time_en_US", with: :real_time do
  indexes specifications_accessories_content
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
