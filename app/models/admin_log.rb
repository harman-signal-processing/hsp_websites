class AdminLog < ApplicationRecord
  belongs_to :user
  belongs_to :website
  validates :user_id, presence: true
  validates :website_id, presence: true
end
