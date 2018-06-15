class Vip::Service < ApplicationRecord
	validates :name, presence: true
	
	has_many :service_service_categories, dependent: :destroy, foreign_key: "vip_service_id"
	has_many :categories, through: :service_service_categories, source: :service_category
	
	has_many :programmer_services, dependent: :destroy, foreign_key:"vip_service_id"
	has_many :programmers, through: :programmer_services
	
end
