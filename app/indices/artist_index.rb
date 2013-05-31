ThinkingSphinx::Index.define :artist, :with => :active_record do
  indexes name, bio
end