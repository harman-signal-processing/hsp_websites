class Faq < ActiveRecord::Base
  belongs_to :product, touch: true
  validates_presence_of :product_id, :question, :answer
  
  def sort_key
    begin
      "#{self.product.name.downcase}#{self.question.downcase}"
    rescue  
      self.question
    end
  end

end
