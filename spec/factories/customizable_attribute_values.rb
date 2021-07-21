FactoryBot.define do
  factory :customizable_attribute_value do
    customizable_attribute
    product
    value { "MyString" }
  end
end
