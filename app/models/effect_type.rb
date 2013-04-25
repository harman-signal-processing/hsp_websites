class EffectType < ActiveRecord::Base
  has_many :effects
  acts_as_list

  after_save :translate

  # Translates this record into other languages. 
  def translate
  	if self.effects && self.effects.first
  		if self.effects.first.products && self.effects.first.products.first
    		ContentTranslation.auto_translate(self, self.effects.first.products.first.brand)
    	end
    end
  end
  handle_asynchronously :translate
end
