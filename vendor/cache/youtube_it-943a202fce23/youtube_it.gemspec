# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "youtube_it"
  s.version = "2.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["kylejginavan", "chebyte"]
  s.date = "2014-11-03"
  s.description = "Upload, delete, update, comment on youtube videos all from one gem."
  s.email = ["kylejginavan@gmail.com", "maurotorres@gmail.com"]
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.md"]
  s.files = ["lib/youtube_it", "lib/youtube_it/chain_io.rb", "lib/youtube_it/client.rb", "lib/youtube_it/middleware", "lib/youtube_it/middleware/faraday_authheader.rb", "lib/youtube_it/middleware/faraday_oauth.rb", "lib/youtube_it/middleware/faraday_oauth2.rb", "lib/youtube_it/middleware/faraday_youtubeit.rb", "lib/youtube_it/model", "lib/youtube_it/model/activity.rb", "lib/youtube_it/model/author.rb", "lib/youtube_it/model/caption.rb", "lib/youtube_it/model/category.rb", "lib/youtube_it/model/comment.rb", "lib/youtube_it/model/contact.rb", "lib/youtube_it/model/content.rb", "lib/youtube_it/model/message.rb", "lib/youtube_it/model/playlist.rb", "lib/youtube_it/model/rating.rb", "lib/youtube_it/model/subscription.rb", "lib/youtube_it/model/thumbnail.rb", "lib/youtube_it/model/user.rb", "lib/youtube_it/model/video.rb", "lib/youtube_it/parser.rb", "lib/youtube_it/record.rb", "lib/youtube_it/request", "lib/youtube_it/request/base_search.rb", "lib/youtube_it/request/error.rb", "lib/youtube_it/request/remote_file.rb", "lib/youtube_it/request/standard_search.rb", "lib/youtube_it/request/user_search.rb", "lib/youtube_it/request/video_search.rb", "lib/youtube_it/request/video_upload.rb", "lib/youtube_it/response", "lib/youtube_it/response/video_search.rb", "lib/youtube_it/version.rb", "lib/youtube_it.rb", "README.rdoc", "youtube_it.gemspec", "CHANGELOG.md"]
  s.homepage = "http://github.com/kylejginavan/youtube_it"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "The most complete Ruby wrapper for youtube api's"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6.0"])
      s.add_runtime_dependency(%q<oauth>, ["~> 0.4.4"])
      s.add_runtime_dependency(%q<oauth2>, ["~> 0.6"])
      s.add_runtime_dependency(%q<simple_oauth>, [">= 0.1.5"])
      s.add_runtime_dependency(%q<faraday>, ["~> 0.8"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<webmock>, [">= 0"])
      s.add_runtime_dependency(%q<excon>, [">= 0"])
      s.add_runtime_dependency(%q<json>, ["~> 1.8"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.6.0"])
      s.add_dependency(%q<oauth>, ["~> 0.4.4"])
      s.add_dependency(%q<oauth2>, ["~> 0.6"])
      s.add_dependency(%q<simple_oauth>, [">= 0.1.5"])
      s.add_dependency(%q<faraday>, ["~> 0.8"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<excon>, [">= 0"])
      s.add_dependency(%q<json>, ["~> 1.8"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.6.0"])
    s.add_dependency(%q<oauth>, ["~> 0.4.4"])
    s.add_dependency(%q<oauth2>, ["~> 0.6"])
    s.add_dependency(%q<simple_oauth>, [">= 0.1.5"])
    s.add_dependency(%q<faraday>, ["~> 0.8"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<excon>, [">= 0"])
    s.add_dependency(%q<json>, ["~> 1.8"])
  end
end
