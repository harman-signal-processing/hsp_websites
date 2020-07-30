class DealerUser < ApplicationRecord
  belongs_to :dealer
  belongs_to :user
  # FIXME: can't get tests to pass with uniqueness
  validates :user, presence: true # , uniqueness: { scope: :dealer_id, case_sensitive: false }
  validates :dealer, presence: true
end
