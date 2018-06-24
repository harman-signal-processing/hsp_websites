class Vip::ProgrammerSiteElement < ApplicationRecord
  belongs_to :programmer, foreign_key: "vip_programmer_id"
  belongs_to :site_element, foreign_key: "site_element_id"
  
  validates :vip_programmer_id, presence: true
  validates :site_element_id, presence: true, uniqueness: { scope: :vip_programmer_id }
  
end
