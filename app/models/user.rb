class User < ActiveRecord::Base
  has_many :online_retailer_users, dependent: :destroy
  has_many :online_retailers, through: :online_retailer_users
  has_many :dealer_users, dependent: :destroy
  has_many :dealers, through: :dealer_users
  has_many :clinics, class_name: "Clinic", foreign_key: "clinician_id" # but only if he's a clinician
  has_many :rep_clinics, class_name: "Clinic", foreign_key: "rep_id" # but only if he's a rep
  has_many :tones
  has_many :tone_user_ratings
  has_one :rso_personal_report
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable,
  # :omniauthable, :validatable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :registerable
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create
  attr_accessor :invitation_code
  validates :invitation_code, presence: true, 
    inclusion: {in: RsoSetting.invitation_code, message: "is invalid. (it is cAsE sEnSiTiVe.)"},
    on: :create,
    if: :rso?

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
    :invitation_code
  
  ROLES = %w[admin 
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
  
  def rso?
    role?(:rso)
  end
  
  # Collect those who have the artist relations role
  #
  def self.artist_relations
    where(artist_relations: true)
  end
end
