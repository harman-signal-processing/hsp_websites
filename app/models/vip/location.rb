class Vip::Location < ApplicationRecord
	validates :city, presence: true
	validates :country, presence: true
	
	has_many :programmer_locations, dependent: :destroy, foreign_key: "vip_location_id"
	has_many :programmers, through: :programmer_locations
	
	has_many :location_global_regions, dependent: :destroy, foreign_key: "vip_location_id"
	has_many :global_regions, through: :location_global_regions
	
	has_many :location_service_areas, dependent: :destroy, foreign_key: "vip_location_id"
	has_many :service_areas, through: :location_service_areas
	
end
