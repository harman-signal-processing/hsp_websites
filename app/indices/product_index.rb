ThinkingSphinx::Index.define :product, :with => :active_record do
  # :nocov:
  indexes name,
  	sap_sku,
  	keywords,
  	description,
  	short_description,
  	extended_description,
  	features,
  	short_description_1,
  	short_description_2,
  	short_description_3,
  	short_description_4
  # :nocov:
end

