# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :label_sheet_order do
    label_sheets { [] }
    mailed_on { "" }
    name { "Joe" }
    email { "joe@joe.com" }
    address { "1233" }
    city { "youhooville" }
    state { "CA" }
    postal_code { "1234" }
    country { "USA" }
    subscribe { false }
    secret_code { "123ABCD" }
  end
end
