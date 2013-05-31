ThinkingSphinx::Index.define :news, :with => :active_record do
  indexes title, body, keywords
end