class Vip::ProgrammerSiteElement < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :site_element, foreign_key: "site_element_id"

  validates :site_element_id, uniqueness: { scope: :vip_programmer_id, case_sensitive: false  }
end
