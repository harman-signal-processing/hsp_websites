class Vip::LocationGlobalRegion < ApplicationRecord
  belongs_to :location, foreign_key: "vip_location_id"
  belongs_to :global_region, foreign_key: "vip_global_region_id"

  validates :vip_global_region_id, uniqueness: { scope: :vip_location_id, case_sensitive: false  }

end
