FactoryBot.define do
  factory :training_course do
    name { "MyString" }
    brand
    description { "MyText-long description" }
    send_registrations_to { "coordinator@harman.com" }
    image_file_name { "MyString.jpg" }
    image_file_size { 1 }
    image_updated_at { 1.day.ago }
    image_content_type { "image/jpeg" }
    short_description { "MyText-short description" }
  end
end
