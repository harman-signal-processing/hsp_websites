# -*- encoding: utf-8 -*-
# stub: will_paginate_infinite 0.1.5 ruby lib

Gem::Specification.new do |s|
  s.name = "will_paginate_infinite".freeze
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Adriano Godoy".freeze, "Adam Anderson".freeze]
  s.date = "2021-01-25"
  s.description = "Will Paginate with infinite scroll".freeze
  s.email = ["godoy.ccp@gmail.com".freeze, "adam@makeascene.com".freeze]
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = [".gitignore".freeze, "README.md".freeze, "app/assets/javascripts/will_paginate_infinite.js".freeze, "app/assets/stylesheets/will_paginate_infinite.scss".freeze, "app/helpers/infinite_helper.rb".freeze, "lib/will_paginate_infinite.rb".freeze, "lib/will_paginate_infinite/infinite_renderer.rb".freeze, "lib/will_paginate_infinite/version.rb".freeze, "will_paginate_infinite.gemspec".freeze]
  s.homepage = "https://github.com/adamtao/will_paginate_infinite".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze, "--charset=UTF-8".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "Will Paginate with infinite scroll".freeze

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<will_paginate>.freeze, [">= 3.1.0"])
  else
    s.add_dependency(%q<will_paginate>.freeze, [">= 3.1.0"])
  end
end
