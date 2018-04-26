class User < ApplicationRecord
  include Gravtastic
  gravtastic
  has_many :online_retailer_users, dependent: :destroy
  has_many :online_retailers, through: :online_retailer_users
  has_many :dealer_users, dependent: :destroy
  has_many :dealers, through: :dealer_users
  has_many :distributor_users, dependent: :destroy
  has_many :distributors, through: :distributor_users
  has_many :tones
  has_many :tone_user_ratings
  has_many :brand_toolkit_contacts # where this user is a contact for a brand
  has_attached_file :profile_pic,
    styles: {
      large:         "550x370",
      medium:        "100x100",
      medium_square: "100x100#",
      thumb:         "64x64",
      thumb_square:  "64x64#",
      tiny:          "32x32",
      tiny_square:   "32x32#",
      super_tiny:    "16x16#"
    }
  validates_attachment :profile_pic, content_type: { content_type: /\Aimage/i }

  serialize :locales, Array # List of locales this person can translate (if they have translator role)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable,
  # :omniauthable, :validatable, :registerable
  devise :database_authenticatable,
    :recoverable,
    :rememberable,
    :trackable,
    :confirmable,
    :registerable

  before_save :add_to_dealer_or_distributor

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create
  validates :invitation_code, presence: true,
    inclusion: {in: [HarmanSignalProcessingWebsite::Application.config.rso_invitation_code,
        HarmanSignalProcessingWebsite::Application.config.employee_invitation_code,
        HarmanSignalProcessingWebsite::Application.config.media_invitation_code],
      message: "is invalid. (it is cAsE sEnSiTiVe.)"},
    on: :create,
    if: :needs_invitation_code?
  validates :account_number, presence: true, on: :create, if: :needs_account_number?

  attr_accessor :invitation_code

  ROLES = %w[admin
    employee
    online_retailer
    customer_service
    translator
    market_manager
    artist_relations
    engineer
    rohs
    clinician
    rep
    distributor
    dealer
    marketing_staff
    rso
    sales_admin
    executive
    technician
    media]

  def self.staff
    where("marketing_staff = 1 OR admin = 1 OR market_manager = 1 OR artist_relations = 1 OR sales_admin = 1").order("UPPER(name)")
  end

  def self.marketing_staff
    where(marketing_staff: true).order(:name)
  end

  def self.default
    u = where(name: "Site Visitor").first_or_initialize do |v|
      v.email = "nobody@lvh.me"
    end
    u.save(validate: false)
    u
  end

  def initials
    @initials ||= (name.split(/\s/).length > 1) ? name.split(/\s/).map{|u| u.match(/^\w/).to_s}.join : name
  end

  def to_s
    self.name
  end

  def display_name
    "testuser"
  end

  def roles
    ROLES.reject{|r| !(eval "self.#{r}")}
  end

  def role?(role)
    roles.include? role.to_s
  end

  def employee?
    role?(:employee) || !!(self.email.to_s.match(/\@harman\.com$/i))
  end

  def rso?
    role?(:rso)
  end

  def dealer?
    role?(:dealer) || self.dealers.length > 0
  end

  def distributor?
    role?(:distributor)
  end

  def rep?
    role?(:rep)
  end

  def media?
    role?(:media)
  end

  def technician?
    role?(:technician)
  end

  def needs_account_number?
    self.dealer? || self.distributor? || self.rep?
  end

  def needs_invitation_code?
    rso? || self.employee? || media?
  end

  # Collect those who have the artist relations role
  #
  def self.artist_relations
    where(artist_relations: true)
  end

  # If this is a dealer user, lookup associated dealer and
  # associate with each other
  def add_to_dealer_or_distributor
    if self.dealer? && self.account_number.present? && self.dealers.length == 0
      self.account_number.gsub!(/^0*/, '')
      if first_dealer = Dealer.where(account_number: self.account_number.to_s).first
        self.dealers << first_dealer
      end
    elsif self.distributor? && self.account_number.present? && self.distributors.length == 0
      self.account_number.gsub!(/^0*/, '')
      if first_distributor = Distributor.where(account_number: self.account_number.to_s).first
        self.distributors << first_distributor
      end
    end
  end

end
