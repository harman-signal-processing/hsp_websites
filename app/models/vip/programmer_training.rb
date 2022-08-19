class Vip::ProgrammerTraining < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :training, foreign_key: "vip_training_id"

  validates :vip_training_id, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
