class Faq < ActiveRecord::Base
  belongs_to :product, touch: true
  validates_presence_of :product_id, :question, :answer
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
