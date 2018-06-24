class Vip::ServiceCategory < ApplicationRecord
	validates :name, presence: true
	
	has_many :service_service_categories, dependent: :destroy, foreign_key: "vip_service_category_id"
	has_many :services, -> { order 'position' }, through: :service_service_categories
end
