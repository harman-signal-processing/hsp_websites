class ProductType < ApplicationRecord

  validates :name, presence: true

  def self.default
    where(default: true).first
  end

  def self.digital_ecom
    where(digital_ecom: true).first
  end
end
