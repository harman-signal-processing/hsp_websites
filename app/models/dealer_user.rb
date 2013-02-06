class DealerUser < ActiveRecord::Base
  attr_accessible :dealer_id, :user_id
  belongs_to :dealer 
  belongs_to :user 
  validate :user_id, presence: true, uniqueness: { scope: :dealer_id }
  validate :dealer_id, presence: true
end
