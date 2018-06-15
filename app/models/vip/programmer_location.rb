class Vip::ProgrammerLocation < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :location, foreign_key: "vip_location_id"
  
  validates :vip_programmer_id, presence: true
  validates :vip_location_id, presence: true, uniqueness: { scope: :vip_programmer_id }
  
end
