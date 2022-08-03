class Vip::ProgrammerLocation < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :location, foreign_key: "vip_location_id"

  validates :vip_location_id, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
