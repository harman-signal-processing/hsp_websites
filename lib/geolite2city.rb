require 'geokit'
require 'maxmind/geoip2'

module Geokit
  module Geocoders

    # Default path on the system for the Maxmind database is:
    #
    #  /usr/share/GeoIP/GeoLite2-City.mmdb
    #
    # Set an environment variable 'maxmind_database_path' to
    # override the path.
    #
    @@geoip2_data_path = (ENV.keys.include?('maxmind_database_path')) ? ENV['maxmind_database_path'] : '/usr/share/GeoIP/GeoLite2-City.mmdb'
    __define_accessors

    class Geolite2CityGeocoder < Geocoder
      def self.do_geocode(ip, optinos={})
        return GeoLoc.new unless /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/.match(ip)

        reader = ::MaxMind::GeoIP2::Reader.new( database: Geocoders::geoip2_data_path )

        begin
          res = reader.city(ip)

          loc = GeoLoc.new({
            provider: 'maxmind2_city',
            lat: res.location.latitude,
            lng: res.location.longitude,
            country_code: res.country.iso_code
          })

          loc.city = (res.city && res.city.name.present?) ? res.city.name : ""
          loc.state = (res.subdivisions.size > 0 && res.subdivisions.first.name.present?) ? res.subdivisions.first.name : ""
          loc.zip = (res.postal.present? && res.postal.code.present?) ? res.postal.code : ""
          loc.success = res.country && res.country.name.present?
          loc
        rescue ::MaxMind::GeoIP2::AddressNotFoundError
          return GeoLoc.new
        end
      end
    end

  end
end
