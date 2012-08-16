class AdminLog < ActiveRecord::Base
  attr_accessible :action, :user_id, :website_id
  belongs_to :user
  belongs_to :website
  validates :user_id, presence: true
  validates :website_id, presence: true
end
