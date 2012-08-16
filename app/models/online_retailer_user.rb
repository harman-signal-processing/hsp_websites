class OnlineRetailerUser < ActiveRecord::Base
  belongs_to :online_retailer
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :online_retailer_id
end
