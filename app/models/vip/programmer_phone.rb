class Vip::ProgrammerPhone < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :phone, foreign_key: "vip_phone_id"
  
  validates :vip_programmer_id, presence: true
  validates :vip_phone_id, presence: true
end
