FactoryBot.define do
  factory :installation do
    brand_id { 1 }
    title { "MyString" }
    keywords { "MyString" }
    description { "MyText" }
    body { "MyText" }
    custom_route { "MyString" }
    cached_slug { "MyString" }
    custom_css { "MyText" }
    layout_class { "MyString" }
  end
end
