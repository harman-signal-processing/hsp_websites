class Vip::Market < ApplicationRecord
	validates :name, presence: true
	
	has_many :programmer_markets, dependent: :destroy, foreign_key: "vip_market_id"
	has_many :programmers, through: :programmer_markets
	
  scope :not_associated_with_this_programmer, -> (programmer) { 
    market_ids_already_associated_with_this_programmer = Vip::ProgrammerMarket.where("vip_programmer_id = ?", programmer.id).map{|programmer_market| programmer_market.vip_market_id }
    markets_not_associated_with_this_programmer = Vip::Market.where.not(id: market_ids_already_associated_with_this_programmer)    
    markets_not_associated_with_this_programmer
  }		
	
end
