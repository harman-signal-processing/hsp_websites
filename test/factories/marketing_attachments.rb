# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_attachment do
    marketing_project_id 1
    marketing_file_file_name "MyString"
    marketing_file_file_size 1
    marketing_file_content_type "MyString"
    marketing_file_updated_at "2013-09-11 15:26:55"
  end
end
