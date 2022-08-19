class ProductFamilyTestimonial < ApplicationRecord
  belongs_to :product_family
  belongs_to :testimonial

  validates :testimonial, uniqueness: { scope: :product_family, case_sensitive: false }

  acts_as_list scope: :product_family
end
