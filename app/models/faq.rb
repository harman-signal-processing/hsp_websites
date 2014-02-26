class Faq < ActiveRecord::Base
  belongs_to :product, touch: true
  validates :product_id, presence: true
  validates :question, presence: true
  validates :answer, presence: true
  after_save :translate
  
  def sort_key
    begin
      "#{self.product.name.downcase}#{self.question.downcase}"
    rescue  
      self.question
    end
  end

  # Translates this record into other languages. 
  def translate
  	if self.product 
    	ContentTranslation.auto_translate(self, self.product.brand)
    end
  end
  handle_asynchronously :translate

end
