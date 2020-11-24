class Vip::ServiceCategory < ApplicationRecord
	validates :name, presence: true
	
	has_many :service_service_categories, dependent: :destroy, foreign_key: "vip_service_category_id"
	has_many :services, -> { order 'position' }, through: :service_service_categories
	
  scope :not_associated_with_this_service, -> (service) { 
    service_category_ids_already_associated_with_this_service = Vip::ServiceServiceCategory.where("vip_service_id = ?", service.id).map{|service_service_categories| service_service_categories.vip_service_category_id }
    service_categories_not_associated_with_this_service = self.where.not(id: service_category_ids_already_associated_with_this_service)    
    service_categories_not_associated_with_this_service
  }	
	
end
