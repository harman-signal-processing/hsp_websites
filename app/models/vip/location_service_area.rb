class Vip::LocationServiceArea < ApplicationRecord
  belongs_to :location, foreign_key: "vip_location_id"
  belongs_to :service_area, foreign_key: "vip_service_area_id"

  validates :vip_service_area_id, uniqueness: { scope: :vip_location_id, case_sensitive: false  }

end
