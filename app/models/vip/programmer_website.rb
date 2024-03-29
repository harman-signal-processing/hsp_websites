class Vip::ProgrammerWebsite < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :website, foreign_key: "vip_website_id"

  validates :vip_website_id, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
