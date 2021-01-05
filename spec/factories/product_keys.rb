FactoryBot.define do
  factory :product_key do
    key { SecureRandom.hex(13) }
    product
  end
end
