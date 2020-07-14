class Vip::ProgrammerCertification < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :certification, foreign_key: "vip_certification_id"
  
  validates :vip_programmer_id, presence: true
  validates :vip_certification_id, presence: true, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
