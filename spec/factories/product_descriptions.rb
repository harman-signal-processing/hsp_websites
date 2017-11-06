FactoryBot.define do
  factory :product_description do
    product
    content_name "description"
    content_part1 "MyText"
    content_part2 "MyText"
  end
end
