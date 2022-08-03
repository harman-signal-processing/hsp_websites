class SoftwareOperatingSystem < ApplicationRecord
  belongs_to :software
  belongs_to :operating_system
  validates :software_id, uniqueness: { scope: :operating_system_id, case_sensitive: false  }
end
