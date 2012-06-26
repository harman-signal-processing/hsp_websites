# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :audio_demo do
    name "MyString"
    description "MyText"
    wet_demo_file_name "MyString"
    wet_demo_file_size 1
    wet_demo_content_type "MyString"
    wet_demo_updated_at "2012-04-09 14:20:02"
    dry_demo_file_name "MyString"
    dry_demo_file_size 1
    dry_demo_content_type "MyString"
    dry_demo_updated_at "2012-04-09 14:20:02"
    duration_in_seconds 1
    brand
  end
end
