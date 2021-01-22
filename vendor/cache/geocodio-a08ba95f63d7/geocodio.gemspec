# -*- encoding: utf-8 -*-
# stub: geocodio 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "geocodio".freeze
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Celis".freeze]
  s.date = "2021-01-22"
  s.description = "Geocodio is a geocoding service that aims to fill a void in the community by allowing developers to geocode large amounts of addresses without worrying about daily limits and high costs.".freeze
  s.email = ["me@davidcel.is".freeze]
  s.files = ["lib/geocodio.rb".freeze, "lib/geocodio/address.rb".freeze, "lib/geocodio/address_set.rb".freeze, "lib/geocodio/client.rb".freeze, "lib/geocodio/client/error.rb".freeze, "lib/geocodio/client/response.rb".freeze, "lib/geocodio/congressional_district.rb".freeze, "lib/geocodio/legislator.rb".freeze, "lib/geocodio/school_district.rb".freeze, "lib/geocodio/state_legislative_district.rb".freeze, "lib/geocodio/timezone.rb".freeze, "lib/geocodio/utils.rb".freeze, "lib/geocodio/version.rb".freeze, "lib/geocodio/zip4.rb".freeze, "spec/address_set_spec.rb".freeze, "spec/address_spec.rb".freeze, "spec/client_spec.rb".freeze, "spec/congressional_district_spec.rb".freeze, "spec/legislator_spec.rb".freeze, "spec/school_district_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/state_legislative_district_spec.rb".freeze, "spec/timezone_spec.rb".freeze, "spec/vcr_cassettes".freeze, "spec/vcr_cassettes/alaska_geocode_with_fields.yml".freeze, "spec/vcr_cassettes/batch_geocode.yml".freeze, "spec/vcr_cassettes/batch_geocode_with_bad_address.yml".freeze, "spec/vcr_cassettes/batch_geocode_with_fields.yml".freeze, "spec/vcr_cassettes/batch_reverse.yml".freeze, "spec/vcr_cassettes/batch_reverse_with_fields.yml".freeze, "spec/vcr_cassettes/geocode.yml".freeze, "spec/vcr_cassettes/geocode_bad_address.yml".freeze, "spec/vcr_cassettes/geocode_with_fields.yml".freeze, "spec/vcr_cassettes/geocode_with_postdirectional.yml".freeze, "spec/vcr_cassettes/geocode_with_zip4.yml".freeze, "spec/vcr_cassettes/invalid_key.yml".freeze, "spec/vcr_cassettes/parse.yml".freeze, "spec/vcr_cassettes/reverse.yml".freeze, "spec/vcr_cassettes/reverse_with_fields.yml".freeze, "spec/vcr_cassettes/reverse_with_fields_no_house_info.yml".freeze, "spec/zip4_spec.rb".freeze]
  s.homepage = "https://github.com/davidcelis/geocodio".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.2".freeze
  s.summary = "An unofficial Ruby client library for geocod.io".freeze
  s.test_files = ["spec/spec_helper.rb".freeze, "spec/client_spec.rb".freeze, "spec/address_set_spec.rb".freeze, "spec/school_district_spec.rb".freeze, "spec/zip4_spec.rb".freeze, "spec/timezone_spec.rb".freeze, "spec/congressional_district_spec.rb".freeze, "spec/vcr_cassettes".freeze, "spec/vcr_cassettes/alaska_geocode_with_fields.yml".freeze, "spec/vcr_cassettes/parse.yml".freeze, "spec/vcr_cassettes/geocode_bad_address.yml".freeze, "spec/vcr_cassettes/geocode.yml".freeze, "spec/vcr_cassettes/batch_reverse_with_fields.yml".freeze, "spec/vcr_cassettes/geocode_with_fields.yml".freeze, "spec/vcr_cassettes/geocode_with_postdirectional.yml".freeze, "spec/vcr_cassettes/reverse.yml".freeze, "spec/vcr_cassettes/batch_geocode_with_fields.yml".freeze, "spec/vcr_cassettes/reverse_with_fields.yml".freeze, "spec/vcr_cassettes/batch_reverse.yml".freeze, "spec/vcr_cassettes/reverse_with_fields_no_house_info.yml".freeze, "spec/vcr_cassettes/batch_geocode_with_bad_address.yml".freeze, "spec/vcr_cassettes/geocode_with_zip4.yml".freeze, "spec/vcr_cassettes/invalid_key.yml".freeze, "spec/vcr_cassettes/batch_geocode.yml".freeze, "spec/state_legislative_district_spec.rb".freeze, "spec/legislator_spec.rb".freeze, "spec/address_spec.rb".freeze]

  s.installed_by_version = "3.1.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
    s.add_development_dependency(%q<vcr>.freeze, [">= 0"])
    s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
  else
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
    s.add_dependency(%q<vcr>.freeze, [">= 0"])
    s.add_dependency(%q<coveralls>.freeze, [">= 0"])
  end
end
