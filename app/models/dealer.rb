class Dealer < ActiveRecord::Base
  attr_accessor :sold_to, :del_flag, :del_block, :order_block # extra fields from import report
  acts_as_mappable
  validates :address, :city, :state, :name, presence: true
  validates :account_number, presence: true, uniqueness: true
  before_validation :format_account_number
  before_validation :geocode_address, on: :create
  before_validation :auto_exclude
  before_update :regeocode
  has_many :dealer_users, dependent: :destroy
  has_many :users, through: :dealer_users
  has_many :brand_dealers, dependent: :destroy
  has_many :brands, through: :brand_dealers
  accepts_nested_attributes_for :brand_dealers

  scope :near, -> (*args) {
    origin = *args.first[:origin]
    if (origin).is_a?(Array)
      origin_lat, origin_lng = origin
    else
      origin_lat, origin_lng = origin.lat, origin.lng
    end
    origin_lat, origin_lng = deg2rad(origin_lat), deg2rad(origin_lng)
    within = *args.first[:within]
    where(
      "(ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(dealers.lat))*COS(RADIANS(dealers.lng))+
      COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(dealers.lat))*SIN(RADIANS(dealers.lng))+
      SIN(#{origin_lat})*SIN(RADIANS(dealers.lat)))*3963) <= #{within[0]}"
    ).select("dealers.*,
      (ACOS(COS(#{origin_lat})*COS(#{origin_lng})*COS(RADIANS(dealers.lat))*COS(RADIANS(dealers.lng))+
      COS(#{origin_lat})*SIN(#{origin_lng})*COS(RADIANS(dealers.lat))*SIN(RADIANS(dealers.lng))+
      SIN(#{origin_lat})*SIN(RADIANS(dealers.lat)))*3963) AS distance"
    )
  }

  def parent
    if !!(self.account_number.match(/^(\d*)\-+\d*$/))
      if p = Dealer.where(account_number: $1).first
        p
      else
        self
      end
    else
      self
    end
  end

  # ship-tos
  def children
    if !!(self.account_number.match(/^(\d*)$/))
      Dealer.where("account_number LIKE ?", "%#{$1}-%")
    end
  end

  # Add this dealer and its children (if any) to the given brand
  def add_to_brand!(brand)
    bd = BrandDealer.where(dealer_id: self.id, brand_id: brand.id).first_or_initialize
    bd.save

    self.children.each do |child|
      bd = BrandDealer.where(dealer_id: child.id, brand_id: brand.id).first_or_initialize
      bd.save
    end
  end

  def format_account_number
    self.account_number = self.account_number.to_s.gsub(/^0*/, '') # ("%010d" % self.account_number.to_i).to_s
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

  # When creating/updating, flag some to be excluded from site search results.
  # Business rules are coded below.
  #
  def auto_exclude
    self.exclude ||= true if !!(address.to_s.match(/p\.?\s?o\.?\sbox/i)) ||  # PO Boxes
      !!(self.del_flag.to_s.match(/\W/)) ||
      !!(self.del_block.to_s.match(/\W/)) ||
      !!(self.order_block.to_s.match(/\W/)) ||
      #account_number.split(/\-/).first.to_i > 700000 || # distributors, internal accounts
      marked_for_deletion? || # those which have deleted-type words in the name
      self.class.excluded_accounts.include?(self.account_number) # those which are flagged in the yaml file
  end

  # Is this Dealer excluded?
  def exclude?
    self.exclude == true || self.class.excluded_accounts.include?(self.account_number)
  end

  # Exclude these account numbers
  def self.excluded_accounts
    @excluded_accounts ||= YAML::load_file(Rails.root.join("db", "excluded_dealers.yml"))
    #%w{100857 103036 103639 103641 101656}
  end

  def marked_for_deletion?
    !!(self.name_and_address.to_s.match(/dl reps|vision 2|deleted|don\'t|deletion|do not|closed|collection|credit|out of business|bankruptcy|amazon\.com|distrib|avad|inactive|freight|mars music|unknown|dig\-|hmg|factory\-|promo/i))
  end
  
end
