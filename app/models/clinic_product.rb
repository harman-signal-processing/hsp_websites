class ClinicProduct < ActiveRecord::Base
  belongs_to :clinic, inverse_of: :clinic_products
  belongs_to :product
  validates :clinic, presence: true
  validates :product_id, presence: true
end
