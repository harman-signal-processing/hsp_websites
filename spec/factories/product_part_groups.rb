FactoryBot.define do
  factory :product_part_group do
    product
    sequence(:name) {|n| "Group-#{n}"}
  end
end
