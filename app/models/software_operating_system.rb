class SoftwareOperatingSystem < ActiveRecord::Base
  attr_accessible :operating_system_id, :software_id
  belongs_to :software 
  belongs_to :operating_system 
  validate :software_id, presence: true, uniqueness: { scope: :operating_system_id }
  validate :operating_system_id, presence: true
end
