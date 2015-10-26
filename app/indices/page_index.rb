ThinkingSphinx::Index.define :page, :with => :active_record do
  # :nocov:
  indexes title, keywords, description, body, custom_route
  # :nocov:
end
