# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :marketing_attachment do
    marketing_project_id 1
    marketing_file { File.new(Rails.root.join('spec', 'fixtures', 'test.jpg')) }
  end
end
