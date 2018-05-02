class ProductPartGroupPart < ApplicationRecord
  belongs_to :part
  belongs_to :product_part_group

  validates :part_id, presence: true, uniqueness: { scope: :product_part_group }
  validates :product_part_group_id, presence: true
end
