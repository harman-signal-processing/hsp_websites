class Dealer < ActiveRecord::Base
  acts_as_mappable
  validates :address, :city, :state, :name, presence: true
  validates :account_number, presence: true, uniqueness: true
  before_validation :format_account_number
  before_validation :geocode_address, on: :create 
  before_update :regeocode
  has_many :dealer_users, dependent: :destroy
  has_many :users, through: :dealer_users
  has_many :brand_dealers, dependent: :destroy
  has_many :brands, through: :brand_dealers
  accepts_nested_attributes_for :brand_dealers
  
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
          (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(dealers.lat))*COS(RADIANS(dealers.lng))+
          COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(dealers.lat))*SIN(RADIANS(dealers.lng))+
          SIN(#{origin_lat})*SIN(RADIANS(dealers.lat)))*3963) <= #{within[0]}
        ),
        select: %( dealers.*,
          (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(dealers.lat))*COS(RADIANS(dealers.lng))+
          COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(dealers.lat))*SIN(RADIANS(dealers.lng))+
          SIN(#{origin_lat})*SIN(RADIANS(dealers.lat)))*3963) AS distance
        )
      }
    }

  def format_account_number
    self.account_number = ("%010d" % self.account_number.to_i).to_s
  end

  # Format the address, city, state, zip into a single string for geocoding
  def address_string
    "#{address}, #{city}, #{state} #{zip}"
  end

  def name_and_address
    "#{name} (#{address_string})"
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
    self.exclude == true || self.class.excluded_accounts.include?(self.account_number)
  end
  
  # Exclude these account numbers
  def self.excluded_accounts
    YAML::load_file(Rails.root.join("db", "excluded_dealers.yml"))
    #%w{100857 103036 103639 103641 101656}
  end
  
end
