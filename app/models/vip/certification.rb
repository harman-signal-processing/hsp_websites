class Vip::Certification < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_certifications, dependent: :destroy, foreign_key: "vip_certification_id"
	has_many :programmers, through: :programmer_certifications
	
  scope :not_associated_with_this_programmer, -> (programmer) { 
    certification_ids_already_associated_with_this_programmer = Vip::ProgrammerCertification.where("vip_programmer_id = ?", programmer.id).map{|programmer_certification| programmer_certification.vip_certification_id }
    certifications_not_associated_with_this_programmer = Vip::Certification.where.not(id: certification_ids_already_associated_with_this_programmer)    
    certifications_not_associated_with_this_programmer
  }	
	
end
