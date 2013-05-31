ThinkingSphinx::Index.define :product, :with => :active_record do
  indexes name, keywords, description, short_description
end