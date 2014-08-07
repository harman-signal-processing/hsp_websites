class Specification < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  belongs_to :product_specification
  has_many :product_specifications
  validates :name, presence: true, uniqueness: true

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
