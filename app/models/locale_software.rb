class LocaleSoftware < ApplicationRecord
  belongs_to :software, touch: true
  validates :software_id, uniqueness: {scope: :locale}
  validates :locale, presence: true
end
