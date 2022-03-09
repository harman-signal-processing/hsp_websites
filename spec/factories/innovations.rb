FactoryBot.define do
  factory :innovation do
    brand
    sequence(:position)
    sequence(:name) {|n| "Innovation #{n}"}
    icon { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
#    icon_file_name { "MyString" }
#    icon_file_size { 1 }
#    icon_content_type { "MyString" }
#    icon_updated_at { "2022-03-09 16:33:18" }
    short_description { "MyText" }
    description { "" }
  end
end
