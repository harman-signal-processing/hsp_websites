class Vip::Website < ApplicationRecord
	validates :url, presence: true
	
	has_many :programmer_websites, dependent: :destroy, foreign_key: "vip_website_id"
	has_many :programmers, through: :programmer_websites
end
