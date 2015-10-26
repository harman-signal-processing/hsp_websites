ThinkingSphinx::Index.define :news, :with => :active_record do
  # :nocov:
  indexes title, body, keywords
  # :nocov:
end
