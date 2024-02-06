# -*- encoding: utf-8 -*-
# stub: chosen-rails 1.10.0 ruby lib

Gem::Specification.new do |s|
  s.name = "chosen-rails".freeze
  s.version = "1.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tse-Ching Ho".freeze]
  s.date = "2024-02-06"
  s.description = "Chosen is a javascript library of select box enhancer for jQuery and Protoype. This gem integrates Chosen with Rails asset pipeline for easy of use.".freeze
  s.email = ["tsechingho@gmail.com".freeze]
  s.files = [".gitignore".freeze, "Gemfile".freeze, "LICENSE".freeze, "README.md".freeze, "Rakefile".freeze, "chosen-rails.gemspec".freeze, "lib/chosen-rails.rb".freeze, "lib/chosen-rails/engine.rb".freeze, "lib/chosen-rails/engine3.rb".freeze, "lib/chosen-rails/railtie.rb".freeze, "lib/chosen-rails/rspec.rb".freeze, "lib/chosen-rails/source_file.rb".freeze, "lib/chosen-rails/tasks.rake".freeze, "lib/chosen-rails/version.rb".freeze, "vendor/assets/images/chosen-sprite.png".freeze, "vendor/assets/images/chosen-sprite@2x.png".freeze, "vendor/assets/javascripts/chosen-jquery.js".freeze, "vendor/assets/javascripts/chosen-prototype.js".freeze, "vendor/assets/javascripts/chosen.jquery.js".freeze, "vendor/assets/javascripts/chosen.proto.js".freeze, "vendor/assets/javascripts/lib/abstract-chosen.js".freeze, "vendor/assets/javascripts/lib/select-parser.js".freeze, "vendor/assets/stylesheets/chosen-base.scss".freeze, "vendor/assets/stylesheets/chosen.scss".freeze]
  s.homepage = "https://github.com/tsechingho/chosen-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.26".freeze
  s.summary = "Integrate Chosen javascript library with Rails asset pipeline".freeze

  s.installed_by_version = "3.3.26" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<railties>.freeze, [">= 3.0"])
    s.add_runtime_dependency(%q<sassc-rails>.freeze, [">= 2.1.2"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 1.0"])
    s.add_development_dependency(%q<rails>.freeze, [">= 3.0"])
    s.add_development_dependency(%q<thor>.freeze, [">= 0.14"])
  else
    s.add_dependency(%q<railties>.freeze, [">= 3.0"])
    s.add_dependency(%q<sassc-rails>.freeze, [">= 2.1.2"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.0"])
    s.add_dependency(%q<rails>.freeze, [">= 3.0"])
    s.add_dependency(%q<thor>.freeze, [">= 0.14"])
  end
end
