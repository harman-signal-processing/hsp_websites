ThinkingSphinx::Index.define :product_family, :with => :active_record do
  # :nocov:
  indexes name, intro, keywords
  # :nocov:
end
