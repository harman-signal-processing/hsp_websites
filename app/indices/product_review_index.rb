ThinkingSphinx::Index.define :product_review, :with => :active_record do
  # :nocov:
  indexes title, body
  # :nocov:
end
