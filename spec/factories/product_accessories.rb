FactoryBot.define do
  factory :product_accessory do
    product
    accessory_product { Product.new }
  end
end
