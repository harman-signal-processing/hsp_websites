class Vip::Service < ApplicationRecord
	validates :name, presence: true
	
	has_many :service_service_categories, dependent: :destroy, foreign_key: "vip_service_id"
	has_many :categories, through: :service_service_categories, source: :service_category
	
	has_many :programmer_services, dependent: :destroy, foreign_key:"vip_service_id"
	has_many :programmers, through: :programmer_services
	
  scope :not_associated_with_this_programmer, -> (programmer) { 
    service_ids_already_associated_with_this_programmer = Vip::ProgrammerService.where("vip_programmer_id = ?", programmer.id).map{|programmer_service| programmer_service.vip_service_id }
    services_not_associated_with_this_programmer = Vip::Service.where.not(id: service_ids_already_associated_with_this_programmer)    
    services_not_associated_with_this_programmer
  }	
  
end
