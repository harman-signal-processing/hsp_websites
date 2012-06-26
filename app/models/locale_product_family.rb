class LocaleProductFamily < ActiveRecord::Base
  belongs_to :product_family
  validates :product_family_id, :presence => true, :uniqueness => {:scope => :locale}
  validates :locale, :presence => true
end
