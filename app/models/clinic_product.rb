class ClinicProduct < ActiveRecord::Base
  belongs_to :clinic, inverse_of: :clinic_products
  belongs_to :product
  validates_presence_of :clinic, :product_id
end
