# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin_log do
    user
    website
    action "MyText"
  end
end
