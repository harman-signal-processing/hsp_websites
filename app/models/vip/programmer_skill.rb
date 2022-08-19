class Vip::ProgrammerSkill < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :skill, foreign_key: "vip_skill_id"

  validates :vip_skill_id, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
