class FaqCategoryFaq < ApplicationRecord
  belongs_to :faq_category
  belongs_to :faq, inverse_of: :faq_category_faqs

  validates :faq_category, presence: true
  validates :faq, presence: true, uniqueness: { scope: :faq_category }
end
