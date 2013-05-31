ThinkingSphinx::Index.define :product_review, :with => :active_record do
  indexes title, body
end