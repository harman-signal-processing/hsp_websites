ThinkingSphinx::Index.define :software, :with => :active_record do
  # :nocov:
  indexes name, version, platform, description
  # :nocov:
end
