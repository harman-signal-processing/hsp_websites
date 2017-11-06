# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :toolkit_resource do
    name "MyToolkitResource"
    toolkit_resource_type
    related_id 1
    tk_preview { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
    download_path "MyString"
    download_file_size 999
    brand
  end
end
