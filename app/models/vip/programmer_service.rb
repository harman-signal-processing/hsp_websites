class Vip::ProgrammerService < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :service, foreign_key: "vip_service_id"

  validates :vip_service_id, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
