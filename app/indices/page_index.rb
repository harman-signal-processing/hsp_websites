ThinkingSphinx::Index.define :page, :with => :active_record do
  indexes title, keywords, description, body, custom_route
end