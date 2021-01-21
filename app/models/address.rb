class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true, touch: true

  validates :addressable_type, presence: true
  validates :addressable_id, presence: true

  alias_attribute :city, :locality
  alias_attribute :state, :region
  alias_attribute :province, :region
  alias_attribute :zipcode, :postal_code

  before_save :standardize

  class << self
    def api_credentials
      @api_credentials ||= SmartyStreets::StaticCredentials.new(ENV['SMARTY_AUTH_ID'], ENV['SMARTY_AUTH_TOKEN'])
    end

    def us_street_api_client
      SmartyStreets::ClientBuilder.new(api_credentials).build_us_street_api_client
    end
  end

  def standardize
    standardize_us_zipcode if is_us_address? && !zipcode_has_plus4?
  end

  def standardize_us_zipcode
    lookup = SmartyStreets::USStreet::Lookup.new
    lookup.street = street_1
    lookup.street2 = street_2
    lookup.secondary = street_3
    lookup.urbanization = street_4
    lookup.city = locality
    lookup.state = region
    lookup.zipcode = postal_code

    begin
      client = Address.us_street_api_client
      client.send_lookup(lookup)
    rescue SmartyStreets::SmartyError => err
      logger.debug err
      return
    end

    unless lookup.result.empty?
      found_address = lookup.result.first
      self.postal_code = found_address.components.zipcode
      self.postal_code += "-#{found_address.components.plus4_code}" if found_address.components.plus4_code.present?
    end
  end

  def is_us_address?
    (country.present? && (country == "US" || country == "USA" || country.match?(/United States/i)))
  end

  def zipcode_has_plus4?
    postal_code.present? && postal_code.match?(/\d{5}\-\d{4}/)
  end

end
