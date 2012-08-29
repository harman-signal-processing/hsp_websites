# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_introduction do
    product_id 1
    layout_class "MyString"
    expires_on "2012-08-29"
    content "MyText"
    extra_css "MyText"
  end
end
