class MarketingComment < ActiveRecord::Base
  attr_accessible :message
  belongs_to :marketing_project
  belongs_to :user
end
