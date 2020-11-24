class Vip::GlobalRegion < ApplicationRecord
	validates :name, presence: true
	
	has_many :location_global_regions, dependent: :destroy, foreign_key: "vip_global_region_id"
	has_many :locations, -> { order 'position' }, through: :location_global_regions
	
  scope :not_associated_with_this_location, -> (location) { 
    global_region_ids_already_associated_with_this_location = Vip::LocationGlobalRegion.where("vip_location_id = ?", location.id).map{|location_global_region| location_global_region.vip_global_region_id }
    global_regions_not_associated_with_this_location = self.where.not(id: global_region_ids_already_associated_with_this_location)    
    global_regions_not_associated_with_this_location
  }		
	
end
