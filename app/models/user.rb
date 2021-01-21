class User < ApplicationRecord
  include Gravtastic
  gravtastic
  has_many :online_retailer_users, dependent: :destroy
  has_many :online_retailers, through: :online_retailer_users
  has_many :dealer_users, dependent: :destroy, inverse_of: :user
  has_many :dealers, through: :dealer_users
  has_many :distributor_users, dependent: :destroy, inverse_of: :user
  has_many :distributors, through: :distributor_users
  has_many :tones
  has_many :tone_user_ratings
  has_many :sales_orders
  has_many :product_keys
  has_many :addresses, as: :addressable, dependent: :destroy

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
    :registerable

  before_create :assign_invited_role
  before_save :add_to_dealer_or_distributor

  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, confirmation: true, on: :create
  validates :invitation_code, presence: true,
    inclusion: {in: [ENV['RSO_INVITATION_CODE'],
        ENV['EMPLOYEE_INVITATION_CODE'],
        ENV['DISTRIBUTOR_INVITATION_CODE'],
        ENV['DEALER_INVITATION_CODE'],
        ENV['TECHNICIAN_INVITATION_CODE'],
        ENV['SUPER_TECHNICIAN_INVITATION_CODE'],
        ENV['MEDIA_INVITATION_CODE'] ],
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
    super_technician
    media
    vip_programmers_admin
    customer
  ]

  def self.staff
    where("marketing_staff = 1 OR admin = 1 OR market_manager = 1 OR artist_relations = 1 OR sales_admin = 1").order(Arel.sql("UPPER(name)"))
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

  def assign_invited_role
    if self.invitation_code.present?
      ROLES.each do |role|
        if self.invitation_code == ENV["#{role.upcase}_INVITATION_CODE"]
          self.send("#{role}=", true)
        end
      end
    end
  end

  def self.new_with_session(params, session)
    new(params) do |user|
      user.customer = true if session[:shopping_cart_id]
    end
  end

  def initials
    @initials ||= (name.split(/\s/).length > 1) ? name.split(/\s/).map{|u| u.match(/^\w/).to_s}.join : name
  end

  def to_s
    display_name
  end

  def display_name
    self.name.present? ? name : email
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

  def super_technician?
    role?(:super_technician)
  end

  def vip_programmers_admin?
    role?(:vip_programmers_admin)
  end

  def needs_account_number?
    self.dealer? || self.distributor? || self.rep?
  end

  def needs_invitation_code?
    !!!self.account_number.present? && self.roles != ["customer"]
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

  def default_address
    if addresses.length > 0
      addresses.first
    else
      Address.new
    end
  end
end
