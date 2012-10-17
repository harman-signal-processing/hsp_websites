# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :label_sheet_order do
    user_id 1
    label_sheet_ids "MyString"
    mailed_on "2012-10-17"
  end
end
