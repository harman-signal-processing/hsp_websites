class ProductKey < ApplicationRecord

  validates :key, presence: true, uniqueness: { case_sensitive: false }

  belongs_to :product
  belongs_to :user # if purchased

end
