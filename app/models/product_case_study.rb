class ProductCaseStudy < ApplicationRecord
  belongs_to :product

  validates :product, presence: true
  validates :case_study_slug,
    presence: true,
    format: { without: /http/i, message: "must be the ID only from the HPro site (not a URL)" }

  acts_as_list scope: :product_id
end
