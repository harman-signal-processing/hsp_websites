# -*- encoding: utf-8 -*-
# stub: lightbox2-rails 2.8.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "lightbox2-rails"
  s.version = "2.8.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gavin Lam"]
  s.date = "2016-06-01"
  s.description = "Lightbox2 for Rails asset pipeline"
  s.email = ["me@gavin.hk"]
  s.files = ["LICENSE", "README.md", "lib/lightbox2", "lib/lightbox2-rails.rb", "lib/lightbox2/rails", "lib/lightbox2/rails.rb", "lib/lightbox2/rails/engine.rb", "lib/lightbox2/rails/version.rb", "vendor/assets", "vendor/assets/images", "vendor/assets/images/lightbox", "vendor/assets/images/lightbox/close.png", "vendor/assets/images/lightbox/loading.gif", "vendor/assets/images/lightbox/next.png", "vendor/assets/images/lightbox/prev.png", "vendor/assets/javascripts", "vendor/assets/javascripts/lightbox.js", "vendor/assets/stylesheets", "vendor/assets/stylesheets/lightbox.scss"]
  s.homepage = "https://github.com/gavinkflam/lightbox2-rails"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Lightbox2 for Rails asset pipeline"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, [">= 3.1"])
    else
      s.add_dependency(%q<railties>, [">= 3.1"])
    end
  else
    s.add_dependency(%q<railties>, [">= 3.1"])
  end
end
