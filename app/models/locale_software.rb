class LocaleSoftware < ApplicationRecord
  belongs_to :software, touch: true
  validates :software_id, presence: true, uniqueness: {scope: :locale}
  validates :locale, presence: true
end
