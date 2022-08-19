class FaqCategoryFaq < ApplicationRecord
  belongs_to :faq_category
  belongs_to :faq, inverse_of: :faq_category_faqs

  validates :faq, uniqueness: { scope: :faq_category, case_sensitive: false }
end
