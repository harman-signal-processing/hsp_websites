ThinkingSphinx::Index.define :artist, :with => :active_record do
  # :nocov:
  indexes name, bio
  # :nocov:
end
