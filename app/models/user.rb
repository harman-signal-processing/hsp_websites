class User < ActiveRecord::Base
  has_many :online_retailer_users, dependent: :destroy
  has_many :online_retailers, through: :online_retailer_users
  has_many :dealer_users, dependent: :destroy
  has_many :dealers, through: :dealer_users
  has_many :clinics, class_name: "Clinic", foreign_key: "clinician_id" # but only if he's a clinician
  has_many :rep_clinics, class_name: "Clinic", foreign_key: "rep_id" # but only if he's a rep
  has_many :tones
  has_many :tone_user_ratings
  has_many :brand_toolkit_contacts # where this user is a contact for a brand
  has_one :rso_personal_report
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable,
  # :omniauthable, :validatable, :registerable
  devise :database_authenticatable, 
    :recoverable, 
    :rememberable, 
    :trackable, 
    :confirmable,
    :registerable

  before_save :add_to_dealer

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create
  validates :invitation_code, presence: true, 
    inclusion: {in: [HarmanSignalProcessingWebsite::Application.config.rso_invitation_code, 
        HarmanSignalProcessingWebsite::Application.config.employee_invitation_code], 
      message: "is invalid. (it is cAsE sEnSiTiVe.)"},
    on: :create,
    if: :needs_invitation_code?
  validates :account_number, presence: true, on: :create, if: :needs_account_number?

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, 
    :name,
    :job_title,
    :job_description,
    :phone_number,
    :password, 
    :password_confirmation, 
    :remember_me,
    :admin, 
    :employee, 
    :online_retailer, 
    :customer_service, 
    :translator, 
    :market_manager, 
    :artist_relations,
    :engineer,
    :rohs,
    :clinician,
    :clinic_admin,
    :rep,
    :distributor,
    :dealer,
    :marketing_staff,
    :rso,
    :rso_admin,
    :sales_admin,
    :account_number,
    :invitation_code

  attr_accessor :invitation_code
  attr_accessor :account_number
  
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
    clinic_admin 
    rep 
    distributor
    dealer
    marketing_staff
    rso 
    rso_admin 
    sales_admin]
  
  def self.staff 
    where("marketing_staff = 1 OR admin = 1 OR market_manager = 1 OR artist_relations = 1 OR sales_admin = 1").order("UPPER(name)")
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
    role?(:employee)
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

  def needs_account_number?
    self.dealer? || self.distributor? || self.rep?
  end

  def needs_invitation_code?
    rso? || self.employee?
  end
  
  # Collect those who have the artist relations role
  #
  def self.artist_relations
    where(artist_relations: true)
  end

  # If this is a dealer user, lookup associated dealer and
  # associate with each other
  def add_to_dealer
    if self.dealer? && self.account_number.present?
      self.account_number.gsub!(/^0*/, '')
      if first_dealer = Dealer.find_by_account_number(self.account_number.to_s)
        self.dealers << first_dealer
      end
    end
  end

end
