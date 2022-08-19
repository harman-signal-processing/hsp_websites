class Vip::ServiceServiceCategory < ApplicationRecord
  belongs_to :service, foreign_key: "vip_service_id"
  belongs_to :service_category, foreign_key: "vip_service_category_id"

  validates :vip_service_category_id, uniqueness: { scope: :vip_service_id, case_sensitive: false  }
end
