class Vip::Phone < ApplicationRecord
	validates :phone, presence: true
	
	has_many :programmer_phones, dependent: :destroy, foreign_key: "vip_phone_id"
	has_many :programmers, through: :programmer_phones
end
