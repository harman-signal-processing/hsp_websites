class LocaleProductFamily < ApplicationRecord
  belongs_to :product_family, touch: true
  validates :product_family_id, presence: true, uniqueness: {scope: :locale}
  validates :locale, presence: true
end
