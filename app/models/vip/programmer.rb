class Vip::Programmer < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_locations, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :locations, -> { order 'position' }, through: :programmer_locations

	has_many :programmer_services, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :services, -> { order 'position' }, through: :programmer_services
	
	has_many :programmer_certifications, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :certifications, -> { order 'position' }, through: :programmer_certifications
	
	has_many :programmer_trainings, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :trainings, -> { order 'position' }, through: :programmer_trainings
	
	has_many :programmer_skills, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :skills, -> { order 'position' }, through: :programmer_skills
	
	has_many :programmer_websites, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :websites, -> { order 'position' }, through: :programmer_websites
	
	has_many :programmer_emails, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :emails, -> { order 'position' }, through: :programmer_emails
	
	has_many :programmer_phones, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :phones, -> { order 'position' }, through: :programmer_phones
	
	has_many :programmer_markets, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :markets, -> { order 'position' }, through: :programmer_markets
	
	has_many :programmer_site_elements, dependent: :destroy, foreign_key: "vip_programmer_id"
	has_many :site_elements, through: :programmer_site_elements

end
