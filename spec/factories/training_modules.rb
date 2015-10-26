FactoryGirl.define do
  factory :training_module do
    sequence(:name) { |n| "Module##{n}" }
    brand
    training_module_file_name "test_file.mov"
    training_module_content_type "application/mov"
    training_module_file_size 1000
    training_module_updated_at 1.day.ago
    description "This the best training module ever"
    width 640
    height 480
  end
end

