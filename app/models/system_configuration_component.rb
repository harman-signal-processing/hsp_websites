class SystemConfigurationComponent < ApplicationRecord
  belongs_to :system_configuration
  belongs_to :system_component

  validates :system_configuration, presence: true
  validates :system_component, presence: true
end
