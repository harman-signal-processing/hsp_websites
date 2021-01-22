class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true, touch: true

  validates :addressable_type, presence: true
  validates :addressable_id, presence: true

  alias_attribute :city, :locality
  alias_attribute :state, :region
  alias_attribute :province, :region
  alias_attribute :zipcode, :postal_code

  before_save :standardize

  def standardize
    standardize_us_zipcode if is_us_address? && !zipcode_has_plus4?
  end

  def standardize_us_zipcode
    g = Geocodio::Client.new

    begin
      results = g.geocode([self.to_s], fields: %w[zip4])
    rescue
      return
    end

    unless results.empty?
      found_address = results.best
      self.postal_code = found_address.zip4.zip9
    end
  end

  def is_us_address?
    (country.present? && (country == "US" || country == "USA" || country.match?(/United States/i)))
  end

  def zipcode_has_plus4?
    postal_code.present? && postal_code.match?(/\d{5}\-\d{4}/)
  end

  def to_s
    to_a.reject(&:blank?).join(", ")
  end

  def to_a
    [street_1, street_2, street_3, street_4, locality, region, postal_code, country]
  end

end
