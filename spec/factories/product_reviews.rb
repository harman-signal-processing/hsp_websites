FactoryBot.define do
  factory :product_review do
    title { "This is a product review" }
    body { "This is the body of the product review." }
  end
end

FactoryBot.define do
  factory :product_review_product do
    product_review
    product
  end
end
