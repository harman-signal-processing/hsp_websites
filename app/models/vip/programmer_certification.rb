class Vip::ProgrammerCertification < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :certification, foreign_key: "vip_certification_id"

  validates :vip_certification_id, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
