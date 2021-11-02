FactoryBot.define do
  factory :product_case_study do
    product
    case_study_slug { "MyString" }
  end
end
