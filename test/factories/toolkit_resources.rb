# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :toolkit_resource do
    name "MyString"
    toolkit_resource_type_id 1
    related_id 1
    tk_preview_file_name "MyString"
    tk_preview_content_type "MyString"
    tk_preview_file_size 1
    tk_preview_updated_at "2013-02-05 11:08:42"
    download_path "MyString"
    download_file_size 1
    brand_id 1
  end
end
