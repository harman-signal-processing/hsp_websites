class OnlineRetailerUser < ActiveRecord::Base
  belongs_to :online_retailer
  belongs_to :user
  validates :user_id, uniqueness: { scope: :online_retailer_id }
end
