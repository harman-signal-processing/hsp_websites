FactoryBot.define do
  factory :get_started_panel do
    get_started_page
    locked_until_registration true
    name "MyString"
    content "MyText"
  end
end
