ThinkingSphinx::Index.define :software, :with => :active_record do
  indexes name, version, platform, description
end