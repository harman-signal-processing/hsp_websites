# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rso_setting do
    sequence(:name) {|n| "setting_#{n}"}
    string_value "HiThere"
  end
end
