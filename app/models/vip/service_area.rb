class Vip::ServiceArea < ApplicationRecord
	validates :name, presence: true
	
	has_many :location_service_areas, dependent: :destroy, foreign_key: "vip_service_area_id"
	has_many :locations, -> { order 'position' }, through: :location_service_areas
end
