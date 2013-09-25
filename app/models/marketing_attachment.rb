class MarketingAttachment < ActiveRecord::Base
  attr_accessible :marketing_file, :marketing_project_id
  belongs_to :marketing_project
  validate :marketing_project_id, presence: true
  has_attached_file :marketing_file
end
