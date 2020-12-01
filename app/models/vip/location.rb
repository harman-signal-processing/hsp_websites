class Vip::Location < ApplicationRecord
	validates :city, presence: true
	validates :country, presence: true
	
	has_many :programmer_locations, dependent: :destroy, foreign_key: "vip_location_id"
	has_many :programmers, through: :programmer_locations
	
	has_many :location_global_regions, dependent: :destroy, foreign_key: "vip_location_id"
	has_many :global_regions, through: :location_global_regions
	
	has_many :location_service_areas, dependent: :destroy, foreign_key: "vip_location_id"
	has_many :service_areas, through: :location_service_areas

  scope :not_associated_with_this_programmer, -> (programmer) { 
    location_ids_already_associated_with_this_programmer = Vip::ProgrammerLocation.where("vip_programmer_id = ?", programmer.id).map{|programmer_location| programmer_location.vip_location_id }
    locations_not_associated_with_this_programmer = self.where.not(id: location_ids_already_associated_with_this_programmer)    
    locations_not_associated_with_this_programmer
  }

end
