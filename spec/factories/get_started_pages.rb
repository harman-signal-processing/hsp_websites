FactoryBot.define do
  factory :get_started_page do
    name { "MyString" }
    header_image { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
    intro { "MyText" }
    details { "MyText" }
    brand
    require_registration_to_unlock_panels { true }
  end
end
