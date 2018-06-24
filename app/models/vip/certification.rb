class Vip::Certification < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_certifications, dependent: :destroy, foreign_key: "vip_certification_id"
	has_many :programmers, through: :programmer_certifications
	
end
