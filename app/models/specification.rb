class Specification < ActiveRecord::Base
  belongs_to :product_specification
  validates_uniqueness_of :name
  validates_presence_of :name
  has_many :product_specifications
  extend FriendlyId
  friendly_id :name
  # after_save :translate # Can't auto translate without a related brand
  
  def values_with_products
    r = {}
    product_specifications.each do |product_specification|
      r[product_specification.value] ||= []
      r[product_specification.value] << product_specification.product
    end
    r
  end

  # Translates this record into other languages. 
  def translate
    ContentTranslation.auto_translate(self, self.brand)
  end
  handle_asynchronously :translate

end
