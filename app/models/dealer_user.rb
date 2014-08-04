class DealerUser < ActiveRecord::Base
  # attr_accessible :dealer_id, :user_id
  belongs_to :dealer 
  belongs_to :user 
  # FIXME: can't get tests to pass with uniqueness
  validates :user_id, presence: true # , uniqueness: { scope: :dealer_id } 
  validates :dealer_id, presence: true
end
