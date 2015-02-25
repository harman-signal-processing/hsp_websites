class FaqCategoryFaq < ActiveRecord::Base
  belongs_to :faq_category
  belongs_to :faq

  validates :faq_category, presence: true
  validates :faq, presence: true, uniqueness: { scope: :faq_category }
end
