FactoryBot.define do
  factory :product_product_filter_value do
    product
    product_filter
    string_value { "MyString" }
    boolean_value { true }
    number_value { 1 }
  end
end
