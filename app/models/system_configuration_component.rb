class SystemConfigurationComponent < ActiveRecord::Base
  belongs_to :system_configuration
  belongs_to :system_component

  validates :system_configuration, presence: true
  validates :system_component, presence: true
end
