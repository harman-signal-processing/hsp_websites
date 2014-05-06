class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  has_many :marketing_projects
  has_many :marketing_tasks, foreign_key: 'worker_id'
  has_many :marketing_comments
  has_many :online_retailer_users, dependent: :destroy
  has_many :online_retailers, through: :online_retailer_users
  has_many :dealer_users, dependent: :destroy
  has_many :dealers, through: :dealer_users
  has_many :distributor_users, dependent: :destroy
  has_many :distributors, through: :distributor_users
  has_many :clinics, class_name: "Clinic", foreign_key: "clinician_id" # but only if he's a clinician
  has_many :rep_clinics, class_name: "Clinic", foreign_key: "rep_id" # but only if he's a rep
  has_many :tones
  has_many :tone_user_ratings
  has_many :brand_toolkit_contacts # where this user is a contact for a brand
  has_one :rso_personal_report
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
    :queue_admin,
    :rso,
    :rso_admin,
    :sales_admin,
    :account_number,
    :media,
    :profile_pic,
    :invitation_code,
    :project_manager,
    :executive

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
    queue_admin
    rso 
    rso_admin 
    sales_admin
    project_manager
    media]
  
  def self.staff 
    where("marketing_staff = 1 OR admin = 1 OR market_manager = 1 OR artist_relations = 1 OR sales_admin = 1").order("UPPER(name)")
  end

  def self.queue_admin(options={})
    default_options = { exclude_super_admins: true, all: false }
    options = default_options.merge options
    a = where(queue_admin: true)
    a = a.where(admin: false) if options[:exclude_super_admins]

    (options[:all]) ? a.order("name").all : a.order("created_at").first
  end

  def self.marketing_staff
    where(marketing_staff: true).order(:name)
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

  def media?
    role?(:media)
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
    if self.dealer? && self.account_number.present?
      self.account_number.gsub!(/^0*/, '')
      if first_dealer = Dealer.where(account_number: self.account_number.to_s).first
        self.dealers << first_dealer
      end
    elsif self.distributor? && self.account_number.present?
      self.account_number.gsub!(/^0*/, '')
      if first_distributor = Distributor.where(account_number: self.account_number.to_s).first
        self.distributors << first_distributor
      end
    end
  end

  def completed_marketing_tasks
    @completed_marketing_tasks ||= marketing_tasks.where("completed_at IS NOT NULL AND completed_at <= ?", Date.tomorrow)
  end

  def incomplete_marketing_tasks
    @incomplete_marketing_tasks ||= marketing_tasks.where("completed_at IS NULL OR completed_at > ?", Date.tomorrow)
  end

  def allocation(offset=nil)
    if offset
      incomplete_marketing_tasks.where("man_hours > 0").where("due_on <= ?", offset).inject(0.0){|total, i| total + i.man_hours}
    else
      incomplete_marketing_tasks.where("man_hours > 0").inject(0.0){|total, i| total + i.man_hours}
    end
  end

end
