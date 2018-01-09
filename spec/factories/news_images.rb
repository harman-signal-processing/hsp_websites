FactoryBot.define do
  factory :news_image do
    news
    hide_from_page false
    image_file_name "MyString"
    image_content_type "MyString"
    image_file_size 1
    image_updated_at 1.day.ago
  end
end
