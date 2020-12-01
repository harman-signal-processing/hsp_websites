class Vip::ServiceArea < ApplicationRecord
	validates :name, presence: true
	
	has_many :location_service_areas, dependent: :destroy, foreign_key: "vip_service_area_id"
	has_many :locations, -> { order 'position' }, through: :location_service_areas
	
  scope :not_associated_with_this_location, -> (location) { 
    service_area_ids_already_associated_with_this_location = Vip::LocationServiceArea.where("vip_location_id = ?", location.id).map{|location_service_area| location_service_area.vip_service_area_id }
    service_areas_not_associated_with_this_location = self.where.not(id: service_area_ids_already_associated_with_this_location)    
    service_areas_not_associated_with_this_location
  }
  
end
