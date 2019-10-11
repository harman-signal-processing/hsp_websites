FactoryBot.define do
  factory :testimonial do
    brand
    title { "MyString" }
    subtitle { "MyString" }
    summary { "MyString" }
    content { "MyText" }
    banner_file_name { "MyString" }
    banner_content_type { "MyString" }
    banner_file_size { 1 }
    banner_updated_at { "2019-10-10 09:53:37" }
    image_file_name { "MyString" }
    image_content_type { "MyString" }
    image_file_size { 1 }
    image_updated_at { "2019-10-10 09:53:37" }
    attachment_file_name { "MyString" }
    attachment_content_type { "MyString" }
    attachment_file_size { 1 }
    attachment_updated_at { "2019-10-10 09:53:37" }
  end
end
