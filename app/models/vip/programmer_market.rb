class Vip::ProgrammerMarket < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :market, foreign_key: "vip_market_id"
  
  validates :vip_programmer_id, presence: true
  validates :vip_market_id, presence: true, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
