FactoryGirl.define do

  factory :content_translation do
    content_type "Product"
    content_method "name"
    content_id 1
    content "foo"
    locale "es"
  end

end
