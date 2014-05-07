# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :toolkit_resource do
    name "MyString"
    toolkit_resource_type
    related_id 1
    tk_preview { File.new(Rails.root.join('test', 'fixtures', 'test.jpg')) }
    download_path "MyString"
    download_file_size 999
    brand
  end
end
