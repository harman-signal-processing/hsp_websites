# -*- encoding: utf-8 -*-
# stub: actionpack-action_caching 1.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "actionpack-action_caching".freeze
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rails/actionpack-action_caching/issues", "changelog_uri" => "https://github.com/rails/actionpack-action_caching/blob/v1.2.1/CHANGELOG.md", "documentation_uri" => "https://www.rubydoc.info/gems/actionpack-action_caching/1.2.1", "source_code_uri" => "https://github.com/rails/actionpack-action_caching/tree/v1.2.1" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2021-04-05"
  s.description = "Action caching for Action Pack (removed from core in Rails 4.0)".freeze
  s.email = "david@loudthinking.com".freeze
  s.files = [".codeclimate.yml".freeze, ".gitignore".freeze, ".rubocop.yml".freeze, ".travis.yml".freeze, "CHANGELOG.md".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "actionpack-action_caching.gemspec".freeze, "gemfiles/Gemfile-4-0-stable".freeze, "gemfiles/Gemfile-4-1-stable".freeze, "gemfiles/Gemfile-4-2-stable".freeze, "gemfiles/Gemfile-5-0-stable".freeze, "gemfiles/Gemfile-5-1-stable".freeze, "gemfiles/Gemfile-5-2-stable".freeze, "gemfiles/Gemfile-6-0-stable".freeze, "gemfiles/Gemfile-6-1-stable".freeze, "gemfiles/Gemfile-edge".freeze, "lib/action_controller/action_caching.rb".freeze, "lib/action_controller/caching/actions.rb".freeze, "lib/actionpack/action_caching.rb".freeze, "lib/actionpack/action_caching/railtie.rb".freeze, "test/abstract_unit.rb".freeze, "test/caching_test.rb".freeze, "test/fixtures/layouts/talk_from_action.html.erb".freeze]
  s.homepage = "https://github.com/rails/actionpack-action_caching".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Action caching for Action Pack (removed from core in Rails 4.0)".freeze
  s.test_files = ["test/abstract_unit.rb".freeze, "test/caching_test.rb".freeze, "test/fixtures/layouts/talk_from_action.html.erb".freeze]

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<actionpack>.freeze, [">= 4.0.0"])
    s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_development_dependency(%q<activerecord>.freeze, [">= 4.0.0"])
  else
    s.add_dependency(%q<actionpack>.freeze, [">= 4.0.0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 4.0.0"])
  end
end
