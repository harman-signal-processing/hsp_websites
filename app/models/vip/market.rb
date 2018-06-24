class Vip::Market < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_markets, dependent: :destroy, foreign_key: "vip_market_id"
	has_many :programmers, through: :programmer_markets
end
