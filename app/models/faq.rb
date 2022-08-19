class Faq < ApplicationRecord

  belongs_to :product, touch: true, optional: true
  has_many :faq_category_faqs, inverse_of: :faq, dependent: :destroy
  has_many :faq_categories, through: :faq_category_faqs

  accepts_nested_attributes_for :faq_category_faqs

  validates :question, presence: true
  validates :answer, presence: true

  def sort_key
    if product
      "#{self.product.name.downcase}#{self.question.downcase}"
    else
      self.question
    end
  end

end
