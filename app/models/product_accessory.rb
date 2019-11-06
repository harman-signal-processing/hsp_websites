class ProductAccessory < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :accessory_product, class_name: "Product", foreign_key: "accessory_product_id", touch: true
end
