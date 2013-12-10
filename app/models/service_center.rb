class ServiceCenter < ActiveRecord::Base
  acts_as_mappable
  validates_presence_of :address, :city, :state, :name, :brand_id
  before_validation :geocode_address, on: :create 
  before_update :regeocode
  belongs_to :brand, touch: true

  scope :near, 
    lambda{ |*args|
      origin = *args.first[:origin]
      if (origin).is_a?(Array)
        origin_lat, origin_lng = origin
      else
        origin_lat, origin_lng = origin.lat, origin.lng
      end
      origin_lat, origin_lng = deg2rad(origin_lat), deg2rad(origin_lng)
      within = *args.first[:within]
      {
        conditions: %(
          (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(service_centers.lat))*COS(RADIANS(service_centers.lng))+
          COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(service_centers.lat))*SIN(RADIANS(service_centers.lng))+
          SIN(#{origin_lat})*SIN(RADIANS(service_centers.lat)))*3963) <= #{within[0]}
        ),
        select: %( service_centers.*,
          (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(service_centers.lat))*COS(RADIANS(service_centers.lng))+
          COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(service_centers.lat))*SIN(RADIANS(service_centers.lng))+
          SIN(#{origin_lat})*SIN(RADIANS(service_centers.lat)))*3963) AS distance
        )
      }
    }
  
  # Format the address, city, state, zip into a single string for geocoding
  def address_string
    "#{address}, #{city}, #{state} #{zip}"
  end
    
  # Geocode if the address has changed
  def regeocode
    self.geocode_address if self.address_changed? || self.city_changed? || self.state_changed?
  end
  
  # Geocode the address and store the lat/lng
  def geocode_address
    geo = Geokit::Geocoders::MultiGeocoder.geocode(self.address_string)
    if geo.success
      self.lat, self.lng = geo.lat, geo.lng 
    else
      puts geo.class
      errors.add(:address, "Could not Geocode address")
    end
  end

  # Is this Dealer excluded?
  def exclude?
    false
    # self.class.excluded_accounts.include?(self.account_number)
  end
  
  # Exclude these account numbers
  def self.excluded_accounts
    YAML::load_file(Rails.root.join("db", "excluded_dealers.yml"))
    #%w{100857 103036 103639 103641 101656}
  end


end
