class BrandToolkitContact < ActiveRecord::Base
  attr_accessible :brand_id, :position, :user_id
  belongs_to :brand 
  belongs_to :user 
  validates :user_id, presence: true, uniqueness: { scope: :brand_id }
  validates :brand_id, presence: true
end
