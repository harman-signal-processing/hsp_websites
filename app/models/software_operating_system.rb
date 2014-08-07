class SoftwareOperatingSystem < ActiveRecord::Base
  belongs_to :software 
  belongs_to :operating_system 
  validates :software_id, presence: true, uniqueness: { scope: :operating_system_id }
  validates :operating_system_id, presence: true
end
