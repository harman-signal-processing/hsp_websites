class LocaleProductFamily < ApplicationRecord
  belongs_to :product_family, touch: true, counter_cache: true
  validates :product_family_id, uniqueness: {scope: :locale}
  validates :locale, presence: true
end
