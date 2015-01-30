# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_introduction do
    product
    layout_class "MyString"
    expires_on 2.months.from_now
    content "MyText"
    extra_css "MyText"
  end
end
