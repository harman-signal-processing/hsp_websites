class ProductCaseStudy < ApplicationRecord
  belongs_to :product

  validates :product, presence: true
  validates :case_study_slug, presence: true

  acts_as_list scope: :product_id
end
