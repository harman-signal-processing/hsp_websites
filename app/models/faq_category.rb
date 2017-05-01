class FaqCategory < ApplicationRecord

  belongs_to :brand
  has_many :faq_category_faqs, dependent: :destroy
  has_many :faqs, through: :faq_category_faqs

  validates :brand, presence: true
  validates :name, presence: true, uniqueness: { scope: :brand_id }

end
