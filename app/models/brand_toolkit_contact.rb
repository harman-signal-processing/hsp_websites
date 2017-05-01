class BrandToolkitContact < ApplicationRecord
  default_scope { order("position") }
  belongs_to :brand
  belongs_to :user
  validates :user_id, presence: true, uniqueness: { scope: :brand_id }
  validates :brand_id, presence: true
  accepts_nested_attributes_for :user, reject_if: :all_blank
  acts_as_list scope: :brand_id
end
