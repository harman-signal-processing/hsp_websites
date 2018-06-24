class Vip::GlobalRegion < ApplicationRecord
	validates :name, presence: true
	
	has_many :location_global_regions, dependent: :destroy, foreign_key: "vip_global_region_id"
	has_many :locations, -> { order 'position' }, through: :location_global_regions
	
end
