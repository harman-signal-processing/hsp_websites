class Vip::ProgrammerEmail < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :email, foreign_key: "vip_email_id"
  
  validates :vip_programmer_id, presence: true
  validates :vip_email_id, presence: true, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
